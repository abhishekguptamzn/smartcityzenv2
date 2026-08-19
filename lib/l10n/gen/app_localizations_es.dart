// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Smart Cityzen';

  @override
  String get appTagline => 'Tu puerta digital a los servicios cívicos';

  @override
  String get welcomeBack => 'Bienvenido de nuevo,';

  @override
  String get tapCardToFlip => 'Toca la tarjeta para voltearla';

  @override
  String get myCity => 'Mi Ciudad';

  @override
  String get cityInformation => 'Información';

  @override
  String get cityNews => 'Noticias';

  @override
  String get cityHistory => 'Historia';

  @override
  String get capitalCity => 'Ciudad Capital';

  @override
  String get timezoneLabel => 'Zona Horaria';

  @override
  String get stateLabel => 'Estado';

  @override
  String get aboutThisCity => 'Sobre Esta Ciudad';

  @override
  String get latestUpdates => 'Últimas Actualizaciones';

  @override
  String get placeholderContentNotice =>
      'Contenido de muestra — actualizaciones en vivo próximamente';

  @override
  String get heritageTimeline => 'Línea de Tiempo del Patrimonio';

  @override
  String get noCityAssigned =>
      'Aún no hay ninguna ciudad vinculada a tu cuenta';

  @override
  String get active => 'Activo';

  @override
  String validTill(String date) {
    return 'Válido hasta $date';
  }

  @override
  String get verifiedMember => 'Miembro Verificado';

  @override
  String get exploreCityServices => 'Explorar Servicios de la Ciudad';

  @override
  String get scanQrToCheckIn => 'Escanear QR para Registrarse';

  @override
  String get pointCameraAtQr =>
      'Apunta tu cámara a un código QR de registro del gimnasio';

  @override
  String get checkInSuccessful => 'Registro Exitoso';

  @override
  String get cameraPermissionDenied =>
      'Se requiere acceso a la cámara para escanear el código QR de registro';

  @override
  String get invalidQrCode =>
      'Este código QR no es un código de registro de gimnasio válido';

  @override
  String get checkingIn => 'Registrando…';

  @override
  String get scanAnyQr => 'Escanear cualquier QR';

  @override
  String get checkInQrSubtitle =>
      'Escanea el código QR de registro de tu membresía';

  @override
  String get uploadQr => 'Subir QR';

  @override
  String get torch => 'Linterna';

  @override
  String get oneAppTitle => 'Una App. Todas las Necesidades de tu Ciudad.';

  @override
  String get oneAppSubtitle =>
      'Accede, conéctate y simplifica tu vida en la ciudad.';

  @override
  String get exploreNow => 'Explorar Ahora';

  @override
  String get faqs => 'Preguntas Frecuentes';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get feedback => 'Comentarios';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get mobileNumber => 'Número de móvil';

  @override
  String get selectYourCity => 'Selecciona tu ciudad';

  @override
  String get createPassword => 'Crear contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get accessPortal => 'Acceder al portal';

  @override
  String get createIdentity => 'Crear identidad';

  @override
  String get orContinueWith => 'O continuar con';

  @override
  String get continueWithGoogle => 'Google';

  @override
  String get continueWithFacebook => 'Facebook';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get sendResetCode => 'Enviar código';

  @override
  String get resetCode => 'Código de restablecimiento';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get backToLogin => 'Volver a iniciar sesión';

  @override
  String get home => 'Inicio';

  @override
  String get services => 'Servicios';

  @override
  String get id => 'ID';

  @override
  String get profile => 'Perfil';

  @override
  String get cityzenIdentity => 'Identidad Cityzen';

  @override
  String get searchServicesHint => 'Buscar servicios, IDs...';

  @override
  String get cityServices => 'Servicios de la ciudad';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get myMemberships => 'Mis membresías';

  @override
  String get manage => 'Administrar';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get libraries => 'Bibliotecas';

  @override
  String get gyms => 'Gimnasios';

  @override
  String get hospitals => 'Hospitales';

  @override
  String get yoga => 'Yoga';

  @override
  String get dance => 'Danza';

  @override
  String get coaching => 'Tutorías';

  @override
  String get photos => 'Fotos';

  @override
  String get more => 'Más';

  @override
  String get searchFacilitiesHint => 'Buscar bibliotecas, gimnasios...';

  @override
  String get openNow => 'Abierto ahora';

  @override
  String get nearMe => 'Cerca de mí';

  @override
  String get freeWifi => 'WiFi gratis';

  @override
  String get filters => 'Filtros';

  @override
  String get closed => 'Cerrado';

  @override
  String get available => 'Disponible';

  @override
  String get limitedSpace => 'Espacio limitado';

  @override
  String kmAway(String distance) {
    return 'A $distance km';
  }

  @override
  String openUntil(String time) {
    return 'Hasta las $time';
  }

  @override
  String get about => 'Acerca de';

  @override
  String get amenities => 'Comodidades';

  @override
  String get hours => 'Horario';

  @override
  String get location => 'Ubicación';

  @override
  String get directions => 'Cómo llegar';

  @override
  String get call => 'Llamar';

  @override
  String get today => 'Hoy';

  @override
  String get membershipDetails => 'Detalles de la membresía';

  @override
  String get validityStatus => 'Estado de validez';

  @override
  String validUntil(String date) {
    return 'Válido hasta $date';
  }

  @override
  String get quickCheckIn => 'Registro rápido';

  @override
  String get checkOut => 'Registrar salida';

  @override
  String get details => 'Detalles';

  @override
  String get attendance => 'Asistencia';

  @override
  String get payments => 'Pagos';

  @override
  String get memberInformation => 'Información del miembro';

  @override
  String get memberId => 'ID de miembro';

  @override
  String get tier => 'Nivel';

  @override
  String get facilityAccess => 'Acceso a instalaciones';

  @override
  String joined(String date) {
    return 'Se unió el $date';
  }

  @override
  String get contactStaffToJoin =>
      'Contacta al personal para unirte a esta instalación';

  @override
  String get contactStaffToRenew =>
      'Contacta al personal para renovar tu membresía';

  @override
  String get contactStaffBody =>
      'La inscripción de autoservicio aún no está disponible. Comunícate directamente con la instalación y nuestro personal configurará tu membresía.';

  @override
  String get sendEmail => 'Enviar correo';

  @override
  String get callFacility => 'Llamar a la instalación';

  @override
  String get myPayments => 'Mis pagos';

  @override
  String get paymentReceipt => 'Recibo de pago';

  @override
  String get amount => 'Monto';

  @override
  String get status => 'Estado';

  @override
  String get paymentMethod => 'Método de pago';

  @override
  String get transactionReference => 'Referencia de transacción';

  @override
  String get invoiceNumber => 'Número de factura';

  @override
  String get dueDate => 'Fecha de vencimiento';

  @override
  String get paidOn => 'Pagado el';

  @override
  String get notes => 'Notas';

  @override
  String get invoiceEmailedNotice =>
      'Se envió una factura PDF detallada por correo cuando se registró este pago.';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get role => 'Rol';

  @override
  String get accountStatus => 'Estado de la cuenta';

  @override
  String get security => 'Seguridad';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get loginHistory => 'Historial de inicio de sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutAllDevices => 'Cerrar sesión en todos los dispositivos';

  @override
  String get suspiciousLogin => 'Sospechoso';

  @override
  String get device => 'Dispositivo';

  @override
  String get ipAddress => 'Dirección IP';

  @override
  String get browser => 'Navegador';

  @override
  String get retry => 'Reintentar';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get noInternetConnection => 'Sin conexión a internet';

  @override
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String get noMembershipsYet => 'Aún no tienes membresías';

  @override
  String get noPaymentsYet => 'Aún no hay historial de pagos';

  @override
  String get noLoginHistoryYet => 'Aún no hay historial de inicio de sesión';

  @override
  String get noExceptionsYet => 'No hay descuentos ni excepciones activas';

  @override
  String get pullToRefresh => 'Desliza para actualizar';

  @override
  String get requiredField => 'Este campo es obligatorio';

  @override
  String get invalidEmail => 'Introduce un correo electrónico válido';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get invalidPhone => 'Introduce un número de teléfono válido';

  @override
  String get errorValidation => 'Revisa los datos que ingresaste';

  @override
  String get errorAuthentication => 'Correo o contraseña incorrectos';

  @override
  String get errorAuthorization => 'No tienes permiso para hacer eso';

  @override
  String get errorAccountBlocked =>
      'Tu cuenta ha sido bloqueada. Contacta a soporte.';

  @override
  String get errorAccountInactive =>
      'Tu cuenta está inactiva. Contacta a soporte.';

  @override
  String get errorNotFound => 'No pudimos encontrar eso';

  @override
  String get errorConflict =>
      'Esta acción entra en conflicto con el estado actual';

  @override
  String errorRateLimited(int seconds) {
    return 'Demasiados intentos. Intenta de nuevo en ${seconds}s';
  }

  @override
  String get errorServer => 'Error del servidor. Intenta de nuevo pronto';

  @override
  String get errorGeneric => 'Error inesperado. Intenta de nuevo';

  @override
  String get settings => 'Configuración';

  @override
  String get networkSettings => 'Red';

  @override
  String get apiBaseUrl => 'URL Base de la API';

  @override
  String get apiBaseUrlHint => 'https://api.example.com/api/v1';

  @override
  String get invalidUrl => 'Introduce una URL válida';

  @override
  String get connectTimeout => 'Tiempo de espera de conexión';

  @override
  String get receiveTimeout => 'Tiempo de espera de recepción';

  @override
  String timeoutSeconds(int seconds) {
    return '$seconds segundos';
  }

  @override
  String get requestLogging => 'Registro de solicitudes';

  @override
  String get requestLoggingSubtitle =>
      'Registrar solicitudes de red para depuración';

  @override
  String get testConnection => 'Probar conexión';

  @override
  String get connectionSuccessful => 'Conexión exitosa';

  @override
  String get connectionFailed => 'Conexión fallida';

  @override
  String get saveAnyway => 'Guardar de todos modos';

  @override
  String get resetToDefaults => 'Restablecer valores predeterminados';

  @override
  String get settingsSaved => 'Configuración guardada';

  @override
  String get confirmResetSettings =>
      'Esto restaurará la URL de la API y los tiempos de espera predeterminados. ¿Continuar?';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystemSubtitle =>
      'Coincide con la configuración de tu dispositivo';

  @override
  String get themeLightSubtitle => 'Usar siempre el tema claro';

  @override
  String get themeDarkSubtitle => 'Usar siempre el tema oscuro';

  @override
  String get activitiesAndAcademies => 'Actividades y Academias';

  @override
  String get allActivities => 'Todas las Actividades';

  @override
  String get verifiedAcademies => 'Academias Verificadas';

  @override
  String get featuredStudios => 'Estudios Destacados';

  @override
  String get batchesAndSchedule => 'Grupos y Horarios';

  @override
  String get coachesAndTrainers => 'Entrenadores y Profesores';

  @override
  String get enrollAndGetPass => 'Inscribirse y Obtener Pase';

  @override
  String get citizenReviews => 'Reseñas Ciudadanas';

  @override
  String get writeReview => 'Escribir Reseña';
}
