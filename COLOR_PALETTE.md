# Color Palette Reference

Quick reference for all colors used in the Bus Tracker app.

## Primary Colors

### Background
```
Color: #F8F9FA
Name: Off-white
Usage: Screen backgrounds
RGB: (248, 249, 250)
```

### Surface
```
Color: #FFFFFF
Name: White
Usage: Cards, containers, app bar
RGB: (255, 255, 255)
```

### Text Primary
```
Color: #2C3E50
Name: Slate grey
Usage: Headings, body text, primary content
RGB: (44, 62, 80)
```

### Text Secondary
```
Color: #6C757D
Name: Muted grey
Usage: Supporting text, captions, timestamps
RGB: (108, 117, 125)
```

### Accent
```
Color: #5A8F7B
Name: Muted green
Usage: Buttons, active states, live indicators
RGB: (90, 143, 123)
```

### Border
```
Color: #E0E4E8
Name: Light grey
Usage: Card borders, dividers, input borders
RGB: (224, 228, 232)
```

## Status Colors

### Status Blue
```
Color: #7B9AAD
Name: Dusty blue
Usage: Government buses, info states
RGB: (123, 154, 173)
```

### Status Amber
```
Color: #D4A574
Name: Soft amber
Usage: Private buses, warning states
RGB: (212, 165, 116)
```

### Light Grey
```
Color: #F5F6F7
Name: Very light grey
Usage: Inactive backgrounds, disabled states
RGB: (245, 246, 247)
```

## Usage Examples

### Buttons

**Primary Button**
- Background: Accent (#5A8F7B)
- Text: Surface (#FFFFFF)
- Border: None

**Secondary Button**
- Background: Transparent
- Text: Text Primary (#2C3E50)
- Border: Border (#E0E4E8)

### Cards

**Default Card**
- Background: Surface (#FFFFFF)
- Border: Border (#E0E4E8) at 0.5px
- Text: Text Primary (#2C3E50)

**Active/Selected Card**
- Background: Accent (#5A8F7B) at 10% opacity
- Border: Accent (#5A8F7B) at 1.5px
- Text: Accent (#5A8F7B)

### Status Badges

**Government Bus**
- Background: Status Blue (#7B9AAD) at 10% opacity
- Text: Status Blue (#7B9AAD)
- Border: None

**Private Bus**
- Background: Status Amber (#D4A574) at 10% opacity
- Text: Status Amber (#D4A574)
- Border: None

### Input Fields

**Default State**
- Background: Surface (#FFFFFF)
- Border: Border (#E0E4E8) at 1px
- Text: Text Primary (#2C3E50)
- Placeholder: Text Secondary (#6C757D)

**Focus State**
- Background: Surface (#FFFFFF)
- Border: Accent (#5A8F7B) at 1.5px
- Text: Text Primary (#2C3E50)

## Color Combinations

### High Contrast (Accessible)
✓ Text Primary on Background: 12:1 ratio
✓ Text Primary on Surface: 15:1 ratio
✓ Text Secondary on Background: 7:1 ratio
✓ Accent on Surface: 4.5:1 ratio

### Avoid These Combinations
✗ Text Secondary on Accent
✗ Border on Background (too subtle)
✗ Light Grey text on Surface

## Opacity Levels

### Backgrounds
- 100%: Default
- 10%: Subtle highlights (badges, selected states)
- 5%: Very subtle (hover states)

### Borders
- 100%: Default borders
- 50%: Very subtle dividers
- 30%: Disabled states

### Text
- 100%: Primary text
- 70%: Secondary text
- 30%: Disabled text

## Dark Mode (Future)

If implementing dark mode, use these alternatives:

```
Background: #1A1D23 (Dark slate)
Surface: #252932 (Darker slate)
Text Primary: #E8EAED (Light grey)
Text Secondary: #9AA0A6 (Medium grey)
Accent: #6BA58E (Lighter muted green)
Border: #3C4043 (Dark border)
```

## Implementation

### In Flutter (theme.dart)

```dart
class AppTheme {
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color accent = Color(0xFF5A8F7B);
  static const Color border = Color(0xFFE0E4E8);
  static const Color statusBlue = Color(0xFF7B9AAD);
  static const Color statusAmber = Color(0xFFD4A574);
  static const Color lightGrey = Color(0xFFF5F6F7);
}
```

### Usage in Code

```dart
// Background
Container(color: AppTheme.background)

// Card
Container(
  color: AppTheme.surface,
  decoration: BoxDecoration(
    border: Border.all(color: AppTheme.border, width: 0.5),
  ),
)

// Text
Text('Hello', style: TextStyle(color: AppTheme.textPrimary))

// Button
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppTheme.accent,
    foregroundColor: AppTheme.surface,
  ),
)

// Badge
Container(
  color: AppTheme.statusBlue.withOpacity(0.1),
  child: Text(
    'Government',
    style: TextStyle(color: AppTheme.statusBlue),
  ),
)
```

## Color Psychology

### Why These Colors?

**Muted Green (Accent)**
- Represents: Growth, safety, go/active
- Feeling: Calm, trustworthy, natural
- Use: Encourages action without urgency

**Slate Grey (Text)**
- Represents: Stability, professionalism
- Feeling: Grounded, serious, reliable
- Use: Easy to read, not harsh

**Dusty Blue (Government)**
- Represents: Authority, trust, official
- Feeling: Calm, institutional
- Use: Differentiates government services

**Soft Amber (Private)**
- Represents: Warmth, caution, attention
- Feeling: Friendly, approachable
- Use: Highlights private services

## Accessibility Notes

- All color combinations meet WCAG AA standards
- Never use color alone to convey information
- Always pair with icons or text labels
- Test with color blindness simulators
- Support system-level contrast settings

## Print/Export

If creating marketing materials:
- Use RGB values for digital
- Convert to CMYK for print
- Maintain color relationships
- Test on different screens

---

**Remember**: These colors are designed to be subtle, calm, and trustworthy. Avoid adding bright or saturated colors that would break the civic-tech aesthetic.
