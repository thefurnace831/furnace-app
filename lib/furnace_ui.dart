import 'package:flutter/material.dart';

class FurnaceColors {
  static const ember = Color(0xFFE94B2E);
  static const amber = Color(0xFFFFC24A);
  static const teal = Color(0xFF1F7976);
  static const ink = Color(0xFF1D1B18);
  static const coal = Color(0xFF2C2722);
  static const smoke = Color(0xFFE5DED3);
  static const clay = Color(0xFFB45A3C);
  static const cream = Color(0xFFFFF8EA);
  static const paper = Color(0xFFFFFCF6);
  static const muted = Color(0xFF766B5F);
}

class FurnaceTheme {
  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: FurnaceColors.ember,
      primary: FurnaceColors.ember,
      secondary: FurnaceColors.teal,
      tertiary: FurnaceColors.amber,
      surface: FurnaceColors.paper,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: FurnaceColors.cream,
    );

    final textTheme = base.textTheme.apply(
      bodyColor: FurnaceColors.ink,
      displayColor: FurnaceColors.ink,
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: FurnaceColors.coal,
          height: 1.35,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: FurnaceColors.paper,
        foregroundColor: FurnaceColors.ink,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: FurnaceColors.ink,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: FurnaceColors.muted),
        prefixIconColor: FurnaceColors.muted,
        suffixIconColor: FurnaceColors.muted,
        border: _fieldBorder(FurnaceColors.smoke),
        enabledBorder: _fieldBorder(FurnaceColors.smoke),
        focusedBorder: _fieldBorder(FurnaceColors.teal, width: 1.8),
        errorBorder: _fieldBorder(FurnaceColors.ember),
        focusedErrorBorder: _fieldBorder(FurnaceColors.ember, width: 1.8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: FurnaceColors.ember,
          foregroundColor: Colors.white,
          disabledBackgroundColor: FurnaceColors.smoke,
          disabledForegroundColor: FurnaceColors.muted,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FurnaceColors.ink,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: const BorderSide(color: FurnaceColors.coal),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FurnaceColors.teal,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: FurnaceColors.ember,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: FurnaceColors.paper,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: FurnaceColors.paper,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: FurnaceColors.coal,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: FurnaceColors.smoke,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class FurnaceBackground extends StatelessWidget {
  final Widget child;
  final bool hallway;
  final bool pattern;
  final bool dark;

  const FurnaceBackground({
    super.key,
    required this.child,
    this.hallway = false,
    this.pattern = false,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? FurnaceColors.ink : FurnaceColors.cream,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hallway)
            Image.asset(
              'assets/images/hallway.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          if (pattern)
            Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: dark
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        FurnaceColors.ink.withAlpha(178),
                        FurnaceColors.ink.withAlpha(232),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        FurnaceColors.cream.withAlpha(245),
                        Colors.white.withAlpha(226),
                        FurnaceColors.smoke.withAlpha(156),
                      ],
                    ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class FurnaceContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final bool scroll;

  const FurnaceContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 32),
    this.maxWidth = 520,
    this.scroll = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );

    content = SafeArea(
      child: Padding(
        padding: scroll ? EdgeInsets.zero : padding,
        child: content,
      ),
    );

    if (!scroll) return content;

    return SafeArea(
      child: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

class FurnacePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const FurnacePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? FurnaceColors.paper.withAlpha(244),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(190)),
        boxShadow: [
          BoxShadow(
            color: FurnaceColors.coal.withAlpha(22),
            offset: const Offset(0, 16),
            blurRadius: 32,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class FurnaceBrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool onDark;
  final double logoWidth;
  final CrossAxisAlignment alignment;

  const FurnaceBrandHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onDark = false,
    this.logoWidth = 260,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final textAlign = alignment == CrossAxisAlignment.center
        ? TextAlign.center
        : TextAlign.left;
    final foreground = onDark ? Colors.white : FurnaceColors.ink;
    final supporting =
        onDark ? Colors.white.withAlpha(210) : FurnaceColors.muted;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: logoWidth,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: textAlign,
          style: TextStyle(
            color: foreground,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: TextStyle(
              color: supporting,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ],
    );
  }
}

class FurnaceSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const FurnaceSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: FurnaceColors.teal.withAlpha(24),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: FurnaceColors.teal, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class FurnaceStatusPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;

  const FurnaceStatusPill({
    super.key,
    required this.label,
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? FurnaceColors.teal : FurnaceColors.clay;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(84)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
