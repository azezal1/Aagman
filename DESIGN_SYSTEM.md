# Bus Tracker Design System

## Design Philosophy

This app follows a **minimal, subtle, and civic-tech aesthetic** designed for real public use in small cities and rural areas of India. The design avoids flashy startup styling and focuses on clarity, accessibility, and trust.

## Color Palette

### Primary Colors

```
Background:     #F8F9FA (Off-white)
Surface:        #FFFFFF (White)
Text Primary:   #2C3E50 (Slate grey)
Text Secondary: #6C757D (Muted grey)
Accent:         #5A8F7B (Muted green)
Border:         #E0E4E8 (Light grey)
```

### Status Colors

```
Status Blue:    #7B9AAD (Dusty blue) - Government buses
Status Amber:   #D4A574 (Soft amber) - Private buses
Light Grey:     #F5F6F7 (Very light grey) - Backgrounds
```

### Usage Guidelines

- **Accent color** only for important actions (buttons, live status)
- **No bright colors** - all colors are muted and soft
- **Status colors** used sparingly for categorization
- **High contrast** between text and background for readability

## Typography

### Font Family
- Primary: System default (San Francisco on iOS, Roboto on Android)
- Fallback: Inter or Poppins for custom implementation

### Font Sizes

```
Headline Large:  24sp (Page titles)
Headline Medium: 20sp (Section headers)
Body Large:      16sp (Primary content)
Body Medium:     14sp (Secondary content)
Label Large:     16sp (Button text)
Small:           12sp (Captions, timestamps)
```

### Font Weights

```
Regular:  400 (Body text)
Medium:   500 (Labels, emphasis)
Semibold: 600 (Headings, important text)
```

### Line Height

```
Body text: 1.5 (24px for 16sp)
Headings:  1.2 (tight)
```

## Spacing System

### Base Unit: 4px

```
4px   - Micro spacing
8px   - Small spacing
12px  - Medium spacing
16px  - Standard spacing (most common)
20px  - Large spacing
24px  - Extra large spacing
32px  - Section spacing
```

### Padding

```
Cards:    16px all sides
Buttons:  16px vertical, 24px horizontal
Screens:  16px all sides
```

### Margins

```
Between elements:  12px
Between sections:  24px
Bottom of cards:   12px
```

## Border Radius

```
Small:   8px  (Tags, chips)
Medium:  10px (Buttons, inputs)
Large:   12px (Cards, containers)
XLarge:  20px (Bottom sheets)
Circle:  50% (Icons, avatars)
```

## Elevation & Shadows

### Minimal Shadow Usage

```
None:   elevation 0 (Most elements)
Subtle: elevation 1 (Cards)
Light:  elevation 2 (Floating elements)
Medium: elevation 4 (Bottom nav, app bar)
```

### Shadow Style
- Color: Black with 5% opacity
- Very soft and subtle
- Only where necessary for depth

## Components

### Buttons

**Primary Button (Elevated)**
- Background: Accent color (#5A8F7B)
- Text: White
- Padding: 16px vertical, 24px horizontal
- Border radius: 12px
- No elevation
- Full width on mobile

**Secondary Button (Outlined)**
- Background: Transparent
- Border: 1px solid Border color
- Text: Text Primary
- Same padding and radius as primary

### Cards

```
Background: Surface white
Border: 0.5px solid Border color
Border radius: 12px
Padding: 16px
Shadow: Minimal (elevation 1)
```

### Input Fields

```
Background: Surface white
Border: 1px solid Border color
Focus border: 1.5px solid Accent
Border radius: 12px
Padding: 16px
Height: 56px minimum
```

### Dropdowns

```
Same as input fields
Icon: Chevron down (20px)
Icon color: Text Secondary
```

### Bottom Navigation

```
Background: Surface white
Height: 64px
Icons: 24px
Selected color: Accent
Unselected color: Text Secondary
Elevation: 8
```

### Status Badges

```
Padding: 6px horizontal, 4px vertical
Border radius: 6px
Font size: 11sp
Background: Status color with 10% opacity
Text: Status color at 100%
```

## Icons

### Style
- Line icons (outlined style)
- Material Icons library
- No filled icons except for active states

### Sizes

```
Small:  16px (In text, badges)
Medium: 20px (In inputs, small buttons)
Large:  24px (Navigation, primary actions)
XLarge: 48px (Feature icons in cards)
Hero:   80px (Empty states)
```

### Colors
- Default: Text Secondary
- Active: Accent
- In colored backgrounds: Match background color

## Layout

### Screen Structure

```
┌─────────────────────┐
│     App Bar         │ 56px height
├─────────────────────┤
│                     │
│   Content Area      │ Scrollable
│   (16px padding)    │
│                     │
├─────────────────────┤
│  Bottom Nav (opt)   │ 64px height
└─────────────────────┘
```

### Grid System
- Mobile: Single column
- Padding: 16px sides
- Max width: 100% (no constraints)

### Touch Targets
- Minimum: 48dp × 48dp
- Recommended: 56dp × 56dp for primary actions

## Accessibility

### Contrast Ratios
- Text Primary on Background: 12:1 (AAA)
- Text Secondary on Background: 7:1 (AA)
- Accent on Surface: 4.5:1 (AA)

### Font Scaling
- Support system font size settings
- Test at 200% scale
- Minimum 14sp for body text

### Touch Targets
- All interactive elements: 48dp minimum
- Spacing between targets: 8dp minimum

## Animation

### Timing
- Fast: 150ms (Micro interactions)
- Normal: 250ms (Most transitions)
- Slow: 350ms (Page transitions)

### Easing
- Standard: Ease-in-out
- Enter: Ease-out
- Exit: Ease-in

### Types
- Fade in/out for overlays
- Slide up for bottom sheets
- Scale for button press feedback
- No complex animations

## Responsive Design

### Breakpoints
- Mobile: < 600px (primary target)
- Tablet: 600px - 900px (stretch layout)
- Desktop: > 900px (not primary focus)

### Adaptations
- Single column on mobile
- Increase padding on larger screens
- Max width 600px for forms on tablet/desktop

## Best Practices

### Do's ✓
- Use muted, soft colors
- Maintain high contrast for text
- Keep spacing consistent (16px base)
- Use simple line icons
- Make touch targets large (48dp+)
- Keep layouts clean and uncluttered
- Use subtle shadows sparingly
- Design for low digital literacy

### Don'ts ✗
- No bright, saturated colors
- No heavy gradients
- No glassmorphism effects
- No neon or glowing effects
- No complex animations
- No tiny text (< 14sp)
- No cluttered cards
- No experimental UI patterns

## Implementation

All design tokens are defined in `lib/config/theme.dart` and can be easily customized.

```dart
// Example usage
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppTheme.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppTheme.border, width: 0.5),
  ),
  child: Text(
    'Content',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```
