import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:miva_pos_app/app/data/models/product.dart';
import 'package:miva_pos_app/app/widgets/miva_card.dart';

class ProductListCard extends StatelessWidget {
  const ProductListCard({super.key, required this.item});
  final Product item;
  @override
  Widget build(BuildContext context) {
    return MivaCard.outline(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl!,
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey,
                    ),
                    width: 35,
                    height: 35,
                    child: const SizedBox.shrink(),
                  ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontFamily: "Inter", fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.tag_outlined,
                        size: 12,
                      ),
                      Text(
                        item.barcodeNumber,
                        style: const TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const Gap(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Terjual : ${item.totalSold!}"),
                      const Gap(22),
                      Text("Stok : ${item.stock != null ? item.stock! : '-'}")
                    ],
                  ),
                  const Gap(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                                locale: 'id', symbol: 'Rp', decimalDigits: 0)
                            .format(item.salePrice),
                        style: const TextStyle(
                            fontFamily: "Inter", fontWeight: FontWeight.w600),
                      ),
                      const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.red,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
