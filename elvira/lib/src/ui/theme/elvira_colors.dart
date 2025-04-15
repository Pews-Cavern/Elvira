import 'package:flutter/material.dart';

/// Cores otimizadas para interfaces de idosos
enum ElviraColor {
  background,
  onBackground,
  primary,
  secondary,
  error,
  surface,
  onSurface,
  interactive,
  success,
  warning, 
}

const elviraColorMap = {
  ElviraColor.background: Color(0xFFF8F9FA),
  ElviraColor.onBackground: Color(0xFF212529),
  ElviraColor.primary: Color(0xFF2C3E50),
  ElviraColor.secondary: Color(0xFF27AE60),
  ElviraColor.error: Color(0xFFC0392B),
  ElviraColor.surface: Color(0xFFECF0F1),
  ElviraColor.onSurface: Color(0xFF2C3E50),
  ElviraColor.interactive: Color(0xFFE67E22),
  ElviraColor.success: Color(0xFF16A085),
  ElviraColor.warning: Color(0xFFF39C12), // Amarelo âmbar
};


/* 
* Os valores de cores foram definidos após uma pesquisa profunda utilizando o perplexity pro, segue as referências

[1] https://aguayo.co/en/blog-aguayo-user-experience/color-and-typography/
[2] https://uxplanet.org/accessible-design-designing-for-the-elderly-41704a375b5d
[3] https://www.frontiersin.org/journals/digital-health/articles/10.3389/fdgth.2023.1289904/full
[4] https://www.hurix.com/blogs/creating-an-accessibility-design-for-seniors-considering-wcag-guidelines/
[5] https://www.digitalpolicy.gov.hk/en/our_work/digital_government/digital_inclusion/accessibility/promulgating_resources/application_design_guide/doc/elderly_friendly_design_guide_eng.pdf
[6] https://www.toptal.com/designers/ui/ui-design-for-older-adults
[7] https://www.tandfonline.com/doi/full/10.1080/10447318.2024.2338659
[8] https://accessibe.com/blog/knowledgebase/ada-compliant-colors
[9] https://www.audioeye.com/post/accessible-colors/
[10] https://mockflow.com/blog/color-psychology-in-ui-design-for-2024
[11] https://www.eleken.co/blog-posts/examples-of-ux-design-for-seniors
[12] https://www.a11y-collective.com/blog/colour-contrast-for-accessibility/
[13] https://www.mdpi.com/2075-5309/12/2/234
[14] https://www.uxmatters.com/mt/archives/2021/09/color-and-universal-design.php
[15] https://daily.dev/blog/color-contrast-guidelines-for-text-and-ui-accessibility
[16] https://www.blueatlasmarketing.com/resources/ada-compliant-colors-helpful-guidelines-and-list-of-tools-to-help/
[17] https://adchitects.co/blog/guide-to-interface-design-for-older-adults
[18] https://www.halo-lab.com/blog/how-contrast-works-in-user-experience-design
[19] https://theclare.com/blog/color-therapy-for-seniors/
[20] https://ux.stackexchange.com/questions/83592/studies-on-color-for-the-elderly

*/