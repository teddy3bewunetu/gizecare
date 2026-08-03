import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gizecare/core/constants/app_assets.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand mark: SVG logo (preferred) + vertically centered wordmark.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.compact = false,
    this.logoSize = 40,
  });

  /// When true, shows only the logo (collapsed sidebar).
  final bool compact;

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    final logo = SizedBox(
      width: logoSize,
      height: logoSize,
      child: SvgPicture.asset(
        AppAssets.logoSvg,
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        placeholderBuilder: (context) => Image.asset(
          AppAssets.logoMark,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );

    if (compact) return logo;

    final ethiopic = GoogleFonts.notoSansEthiopic(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.0,
    );
    final latin = GoogleFonts.spaceGrotesk(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.0,
      letterSpacing: -0.2,
    );

    return SizedBox(
      height: logoSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: 10),
          Flexible(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'ጊዜ', style: ethiopic),
                    TextSpan(text: 'Care', style: latin),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
