import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuickAccessIcons extends StatelessWidget {
  const QuickAccessIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            _QuickAccessItem(
              icon: Icons.history,
              label: 'Histórico',
              onTap: () {
                // TODO: Navegar para histórico
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Histórico em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.location_on_outlined,
              label: 'Endereço',
              onTap: () {
                // TODO: Navegar para endereços
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Endereços em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.payment,
              label: 'Pagamento',
              onTap: () {
                // TODO: Navegar para pagamentos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pagamentos em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.favorite_border,
              label: 'Favoritos',
              onTap: () {
                // TODO: Navegar para favoritos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favoritos em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.shopping_bag_outlined,
              label: 'Pedidos',
              onTap: () {
                // TODO: Navegar para pedidos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pedidos em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.card_giftcard,
              label: 'Bônus',
              onTap: () {
                // TODO: Navegar para bônus
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bônus em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.local_offer_outlined,
              label: 'Cupons',
              onTap: () {
                // TODO: Navegar para cupons
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cupons em breve!')),
                );
              },
            ),
            _QuickAccessItem(
              icon: Icons.help_outline,
              label: 'Ajuda',
              onTap: () {
                // TODO: Navegar para ajuda
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ajuda em breve!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: Colors.black87,
            ),
            SizedBox(height: 0.8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
