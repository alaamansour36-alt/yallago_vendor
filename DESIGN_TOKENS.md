# YallaGo Flutter Design Tokens

The Flutter source retains the approved **Nile Pulse** direction: Arabic-first information hierarchy, Nile Blue wayfinding, Hibiscus Red for order-critical conversion, papyrus surfaces, ticket labels, and route-line motifs.

| Token | Value | Flutter use |
|---|---:|---|
| Nile Blue | `#006E90` | `AppColors.nile`; primary navigation, active states, confirmation actions. |
| Deep Nile | `#004E68` | `AppColors.nileDark`; headers, dark route surfaces, strong hierarchy. |
| Hibiscus Red | `#E84757` | `AppColors.hibiscus`; cart dock and the final order placement action only. |
| Papyrus | `#F7F4ED` | `AppColors.papyrus`; application background. |
| Paper | `#FFFFFA` | `AppColors.paper`; cards, inputs, elevated surfaces. |
| Ink | `#172B35` | `AppColors.ink`; Vendor surface and primary text. |
| Mist | `#E7F3F6` | `AppColors.mist`; selected chips and operational highlights. |
| Operational Green | `#188A68` | `AppColors.green`; confirmed workflow steps only. |
| Divider | `#E4E0D7` | `AppColors.line`; low-contrast outlines and separators. |

The current source uses the device’s sans-serif font stack to avoid runtime font downloads. For the release build, bundle **Alexandria** for Arabic display/metadata and **Manrope** for English/UI labels as local font assets, then register them in `pubspec.yaml` and update `ThemeData.fontFamily`.

| Scale | Flutter value | Use |
|---|---:|---|
| Display | 34 px / 800 | Splash statement only. |
| Screen title | 28–30 px / 800 | Main page and restaurant titles. |
| Section title | 18 px / 800 | Group headings. |
| Body | 14–15 px | Primary readable content. |
| Metadata | 11–12 px | Timing, delivery, tags, supporting text. |
| Compact ticket | 9–10 px / 800 | Status and route labels. |

The base spacing unit is **4 px**. Repeated values in the source are 8, 10, 12, 14, 16, 18, 20, and 24 px. Mobile page padding is 20 px horizontally. Cards use 17–23 px radii with a deliberately sharper lower-end corner to preserve the Cairo ticket/wayfinding character.
