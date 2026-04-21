import 'package:flutter/material.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/onboarding/step1_name_screen.dart';
import '../../features/onboarding/step2_gender_screen.dart';
import '../../features/onboarding/step3_caregiver_screen.dart';
import '../../features/onboarding/step4_accessibility_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/discagem/discagem_screen.dart';
import '../../features/contatos/contatos_screen.dart';
import '../../features/remedios/remedios_hoje_screen.dart';
import '../../features/remedios/alarme_fullscreen.dart';
import '../../features/identidade/identidade_screen.dart';
import '../../features/emergencia/emergencia_screen.dart';
import '../../features/notificacoes/notificacoes_screen.dart';
import '../../features/cuidador/pin_login_screen.dart';
import '../../features/cuidador/cuidador_home_screen.dart';
import '../../features/cuidador/medicamentos/medicamentos_list_screen.dart';
import '../../features/cuidador/medicamentos/medicamento_form_screen.dart';
import '../../features/cuidador/contatos/contatos_admin_screen.dart';
import '../../features/cuidador/contatos/contato_form_screen.dart';
import '../../features/cuidador/identidade/identidade_form_screen.dart';
import '../../features/cuidador/relatorios/relatorios_screen.dart';
import '../../features/cuidador/configuracoes/configuracoes_screen.dart';
import '../../features/institucional/sobre_screen.dart';
import '../../features/institucional/privacidade_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const welcome = '/onboarding/welcome';
  static const step1 = '/onboarding/step1';
  static const step2 = '/onboarding/step2';
  static const step3 = '/onboarding/step3';
  static const step4 = '/onboarding/step4';

  static const home = '/home';
  static const discagem = '/discagem';
  static const contatos = '/contatos';
  static const remedios = '/remedios';
  static const alarme = '/alarme';
  static const identidade = '/identidade';
  static const emergencia = '/emergencia';
  static const notificacoes = '/notificacoes';

  static const cuidadorPin = '/cuidador/pin';
  static const cuidadorHome = '/cuidador/home';
  static const cuidadorMedicamentos = '/cuidador/medicamentos';
  static const cuidadorMedicamentoForm = '/cuidador/medicamentos/form';
  static const cuidadorContatos = '/cuidador/contatos';
  static const cuidadorContatoForm = '/cuidador/contatos/form';
  static const cuidadorIdentidade = '/cuidador/identidade';
  static const cuidadorRelatorios = '/cuidador/relatorios';
  static const cuidadorConfiguracoes = '/cuidador/configuracoes';

  static const sobre = '/sobre';
  static const privacidade = '/privacidade';

  static Map<String, WidgetBuilder> get routes => {
        welcome: (_) => const WelcomeScreen(),
        step1: (_) => const Step1NameScreen(),
        step2: (_) => const Step2GenderScreen(),
        step3: (_) => const Step3CaregiverScreen(),
        step4: (_) => const Step4AccessibilityScreen(),
        home: (_) => const HomeScreen(),
        discagem: (_) => const DiscagemScreen(),
        contatos: (_) => const ContatosScreen(),
        remedios: (_) => const RemediosHojeScreen(),
        alarme: (_) => const AlarmeFullscreen(),
        identidade: (_) => const IdentidadeScreen(),
        emergencia: (_) => const EmergenciaScreen(),
        notificacoes: (_) => const NotificacoesScreen(),
        cuidadorPin: (_) => const PinLoginScreen(),
        cuidadorHome: (_) => const CuidadorHomeScreen(),
        cuidadorMedicamentos: (_) => const MedicamentosListScreen(),
        cuidadorMedicamentoForm: (_) => const MedicamentoFormScreen(),
        cuidadorContatos: (_) => const ContatosAdminScreen(),
        cuidadorContatoForm: (_) => const ContatoFormScreen(),
        cuidadorIdentidade: (_) => const IdentidadeFormScreen(),
        cuidadorRelatorios: (_) => const RelatoriosScreen(),
        cuidadorConfiguracoes: (_) => const ConfiguracoesScreen(),
        sobre: (_) => const SobreScreen(),
        privacidade: (_) => const PrivacidadeScreen(),
      };
}
