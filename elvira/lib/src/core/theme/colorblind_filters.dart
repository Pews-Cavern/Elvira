import 'package:flutter/material.dart';

/// Modos de correção de cores para pessoas daltônicas.
enum ColorBlindMode {
  normal,
  protanopia,
  deuteranopia,
  tritanopia;

  String get id => name;

  static ColorBlindMode fromId(String id) {
    return ColorBlindMode.values.firstWhere(
      (m) => m.id == id,
      orElse: () => ColorBlindMode.normal,
    );
  }

  String get label {
    switch (this) {
      case ColorBlindMode.normal:
        return 'Sem correção';
      case ColorBlindMode.protanopia:
        return 'Protanopia (dificuldade com vermelho)';
      case ColorBlindMode.deuteranopia:
        return 'Deuteranopia (dificuldade com verde)';
      case ColorBlindMode.tritanopia:
        return 'Tritanopia (dificuldade com azul/amarelo)';
    }
  }
}

/// Matrizes de correção (daltonização) para cada modo.
/// Realçam as cores que cada tipo de daltonismo tem mais dificuldade
/// em distinguir, deslocando o "erro" de percepção para outros canais.
const Map<ColorBlindMode, List<double>> _correctionMatrices = {
  ColorBlindMode.protanopia: [
    1.000000, 0.000000, 0.000000, 0, 0,
    0.287338, 0.686147, 0.026515, 0, 0,
    0.358369, -0.413215, 1.054846, 0, 0,
    0, 0, 0, 1, 0,
  ],
  ColorBlindMode.deuteranopia: [
    1.000000, 0.000000, 0.000000, 0, 0,
    0.097674, 0.835028, 0.067299, 0, 0,
    0.272817, -0.387235, 1.114418, 0, 0,
    0, 0, 0, 1, 0,
  ],
  ColorBlindMode.tritanopia: [
    0.844695, -0.244325, 0.399629, 0, 0,
    0.045059, 0.751140, 0.203801, 0, 0,
    0.000000, 0.000000, 1.000000, 0, 0,
    0, 0, 0, 1, 0,
  ],
};

/// Retorna o filtro de cor a aplicar na interface para o modo informado,
/// ou `null` se nenhuma correção deve ser aplicada.
ColorFilter? colorFilterFor(ColorBlindMode mode) {
  final matrix = _correctionMatrices[mode];
  if (matrix == null) return null;
  return ColorFilter.matrix(matrix);
}
