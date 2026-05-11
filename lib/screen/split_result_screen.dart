import 'package:flutter/material.dart';
import 'package:frontend/components/warn_components.dart';

import '../components/app_layout.dart';
import '../util/color.dart';
import '../util/string.dart';

class SplitResultScreen extends StatefulWidget {
  const SplitResultScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplitResultScreenState();
}

class _SplitResultScreenState extends State<SplitResultScreen> {
  int selectedRadio = 1;

  // 참여자 상태 관리
  List<Map<String, dynamic>> participants = [
    {'name': '나', 'amount' : 30000, 'isDone' : false, 'isOwner' : true},
    {'name': '김나영', 'amount': 30000, 'isDone' : true, 'isOwner' : false},
    {'name': '김동현', 'amount': 30000, 'isDone' : false, 'isOwner' : false},
    {'name': '박지민', 'amount': 30000, 'isDone' : true, 'isOwner' : false},
    {'name': '유지호', 'amount': 30000, 'isDone' : true, 'isOwner' : false},
  ];

  int totalAmount = 0;


  @override
  Widget build(BuildContext context) {
    // [추가] 현재 입력된 금액의 합 계산
    totalAmount = participants.map((p) => p['amount'] as int).toList().reduce((sum, amount) => sum + amount);
    int currentSum = participants.fold(0, (sum, p) => sum + (p['amount'] as int));

    // [추가] 직접 입력 모드이면서, 총합이 맞지 않을 때 에러 상태
    bool isError = selectedRadio == 2 && currentSum != totalAmount;
    int diff = totalAmount - currentSum; // 차액 계산

    return AppLayout(
      title: '정산 결과',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 총 금액 카드
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                children: [
                  const Text('총 결제 금액', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text('${formatCurrency(totalAmount)}원', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. 정산 방식 카드
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 12, bottom: 8),
                    child: Text('정산 방식 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _buildCustomRadio(
                    value: 1,
                    title: '균등 분할',
                    description: '모든 인원이 동일한 금액을 냅니다.',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                  ),
                  _buildCustomRadio(
                    value: 2,
                    title: '금액 직접 입력',
                    description: '참여자별로 낼 금액을 직접 입력합니다.',
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. 참여자별 결과 카드
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('참여자별 정산 결과', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),

                  // 참여자 리스트
                  ...participants.map((person) => _buildResultRow(
                      person['name'],
                      person['amount'],
                      isOwner: person['isOwner'],
                      canEdit: selectedRadio == 2
                  )),

                  // [핵심 추가] 에러 발생 시 붉은색 알림 박스 표시
                  if (isError) ...[
                    const SizedBox(height: 16),
                    WarnComponents(text: diff > 0
                        ? '총 금액보다 ${formatCurrency(diff)}원 부족합니다.'
                        : '총 금액보다 ${formatCurrency(diff.abs())}원 초과되었습니다.',)
                  ]
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 하단 버튼
            ElevatedButton(
              // [추가] 에러가 있으면 버튼 비활성화 (null 전달)
              onPressed: isError ? null : () => Navigator.pushNamed(context, '/qr_payment', arguments: participants),
              style: ElevatedButton.styleFrom(
                // 에러 상태일 때는 버튼 색상을 회색으로 변경
                backgroundColor: isError ? Colors.grey.shade300 : kPrimaryColor,
                foregroundColor: isError ? Colors.grey.shade600 : Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('결제 요청하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 바텀시트
  void _showEditAmountBottomSheet(String name, int currentAmount) {
    final TextEditingController controller = TextEditingController(text: currentAmount.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 32,
                bottom: MediaQuery.of(context).viewInsets.bottom + 32,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Material(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$name님의 금액 수정', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        suffixText: '원',
                        suffixStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FA),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final index = participants.indexWhere((p) => p['name'] == name);
                          participants[index]['amount'] = int.tryParse(controller.text) ?? 0;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('수정 완료', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 행 구성
  Widget _buildResultRow(String name, int amount, {bool isOwner = false, bool canEdit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            child: Text(name[0], style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          GestureDetector(
            onTap: canEdit ? () => _showEditAmountBottomSheet(name, amount) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${formatCurrency(amount)}원',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
                if (canEdit) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.edit, size: 18, color: Colors.grey),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 라디오버튼
  Widget _buildCustomRadio({required int value, required String title, required String description}) {
    bool isSelected = selectedRadio == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedRadio = value;
          // [추가] '균등 분할'을 선택하면 금액을 자동으로 총합에 맞춰 초기화
          if (selectedRadio == 1) {
            int splitAmount = totalAmount ~/ participants.length;
            for (var p in participants) {
              p['amount'] = splitAmount;
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24, height: 24,
                  child: Radio<int>(
                    value: value,
                    groupValue: selectedRadio,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          selectedRadio = v;
                          if (selectedRadio == 1) {
                            int splitAmount = totalAmount ~/ participants.length;
                            for (var p in participants) {
                              p['amount'] = splitAmount;
                            }
                          }
                        });
                      }
                    },
                    activeColor: kPrimaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuart,
              alignment: Alignment.topCenter,
              clipBehavior: Clip.hardEdge,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 36),
                child: isSelected
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                )
                    : const SizedBox(height: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}