import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart'; // CupertinoActivityIndicator 사용을 위해 추가
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart'; // 메시지 앱 호출을 위해 추가

import '../components/app_layout.dart';
import '../util/color.dart';

class SplitSetupScreen extends StatefulWidget {
  const SplitSetupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplitSetupScreenState();
}

class _SplitSetupScreenState extends State<SplitSetupScreen> {
  List<Contact> _contacts = []; // 전체 연락처 목록
  List<Contact> _filteredContacts = []; // 검색 필터링된 연락처 목록
  final Set<String> _selectedContactIds = {}; // 선택된 연락처 식별자 저장

  bool _isLoading = true; // 로딩 상태 (Cupertino 인디케이터용)
  bool _hasPermission = false; // 권한 획득 여부

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getContacts();
    });
  }

  Future<void> getContacts() async {
    if(kIsWeb) {
      setState(() {
        _isLoading = false;
      });
    } else {
      if (await Permission.contacts.request().isGranted) {
        // 접근권한을 얻을 시 실행되는 기능
        var contacts = await ContactsService.getContacts(
          withThumbnails: false,
        );

        // 가져온 연락처 목록 변수에 할당 및 초기화
        setState(() {
          _contacts = contacts.toList();
          _filteredContacts = _contacts;
          _hasPermission = true;
          _isLoading = false;
        });
      } else {
        // 권한 거부 시
        setState(() {
          _hasPermission = false;
          _isLoading = false;
        });
      }
    }
  }

  // 1. 이름 검색 기능
  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts.where((contact) {
          final name = contact.displayName ?? '';
          return name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // 2. 리스트 선택 토글 기능
  void _toggleSelection(String id) {
    setState(() {
      if (_selectedContactIds.contains(id)) {
        _selectedContactIds.remove(id);
      } else {
        _selectedContactIds.add(id);
      }
    });
  }

  // 3. 초대 링크 SMS 발송 기능
  Future<void> _sendInviteMessage() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      queryParameters: <String, String>{
        'body': '[더치페이] 정산 테이블에 초대합니다! 링크를 눌러 참여해주세요.\n🔗 https://dutchpay.app/invite/1234',
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('메시지 앱을 열 수 없습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. 다음으로 넘어가기 조건 (권한이 있고, 1명 이상 선택했을 때만 활성화)
    bool canGoNext = (_hasPermission && _selectedContactIds.isNotEmpty) || kIsWeb;

    return AppLayout(
      title: '정산 테이블',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('참여자 추가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  '${_selectedContactIds.length}명 선택',
                  style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                )
              ],
            ),
            const SizedBox(height: 16),

            // 검색창
            TextField(
              onChanged: _filterContacts, // 검색어 입력 시 필터링 수행
              enabled: _hasPermission, // 권한이 없으면 검색창 비활성화
              decoration: InputDecoration(
                hintText: '이름 검색',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 참여자 리스트 카드
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: kCardShadow,
                ),
                child: _isLoading
                // [핵심] iOS 스타일의 Cupertino 로딩 인디케이터 적용
                    ? const Center(child: CupertinoActivityIndicator(radius: 16))
                    : (!_hasPermission || _contacts.isEmpty)
                // 연락처가 없거나 권한이 없는 경우의 예외 처리 화면
                    ? Center(
                  child: Text(
                    kIsWeb ? '웹 환경에서는 연락처를 가져올 수 없습니다.' : (!_hasPermission ? '연락처 접근 권한이 필요합니다.' : '연락처가 없습니다.'),
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _filteredContacts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  itemBuilder: (context, index) {
                    final contact = _filteredContacts[index];
                    // 고유 식별자 (identifier가 없으면 이름 또는 인덱스를 임시로 사용)
                    final String id = contact.identifier ?? contact.displayName ?? index.toString();
                    final bool isSelected = _selectedContactIds.contains(id);
                    final String displayName = contact.displayName ?? '(알 수 없음)';

                    return ListTile(
                      onTap: () => _toggleSelection(id), // 탭해서 선택/해제
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: CircleAvatar(
                        // 선택 여부에 따라 아바타 색상 변경
                        backgroundColor: isSelected ? kPrimaryColor : kPrimaryColor.withOpacity(0.1),
                        child: Text(
                          displayName.isNotEmpty ? displayName[0] : '?',
                          style: TextStyle(
                              color: isSelected ? Colors.white : kPrimaryColor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      title: Text(displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? kPrimaryColor : Colors.grey[300],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // [추가] 문자 메시지로 초대 링크 발송 버튼
            OutlinedButton(
              onPressed: _sendInviteMessage,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                side: const BorderSide(color: kPrimaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, color: kPrimaryColor),
                  SizedBox(width: 8),
                  Text('초대 링크 문자로 발송하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryColor)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 하단 버튼 (조건 불충족 시 null로 비활성화)
            ElevatedButton(
              onPressed: canGoNext ? () => Navigator.pushNamed(context, '/split_result') : null,
              style: ElevatedButton.styleFrom(
                // 비활성화 상태일 때는 회색 계열로 표시
                backgroundColor: canGoNext ? kPrimaryColor : Colors.grey.shade300,
                foregroundColor: canGoNext ? Colors.white : Colors.grey.shade600,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('다음으로', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}