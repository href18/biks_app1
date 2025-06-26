import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_no.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('no')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hydraulic Calculator'**
  String get appTitle;

  /// No description provided for @firstMenu.
  ///
  /// In en, this message translates to:
  /// **'Lift Calculator'**
  String get firstMenu;

  /// No description provided for @secondMenu.
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get secondMenu;

  /// No description provided for @courseMenu.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courseMenu;

  /// No description provided for @liftingTable.
  ///
  /// In en, this message translates to:
  /// **'Lifting Chart'**
  String get liftingTable;

  /// No description provided for @threadChart.
  ///
  /// In en, this message translates to:
  /// **'Thread Chart'**
  String get threadChart;

  /// No description provided for @gTable.
  ///
  /// In en, this message translates to:
  /// **'G-Table'**
  String get gTable;

  /// No description provided for @myLifts.
  ///
  /// In en, this message translates to:
  /// **'My Lifts'**
  String get myLifts;

  /// No description provided for @dailyCheck.
  ///
  /// In en, this message translates to:
  /// **'Daily Check'**
  String get dailyCheck;

  /// No description provided for @typeControl.
  ///
  /// In en, this message translates to:
  /// **'Type Control'**
  String get typeControl;

  /// No description provided for @inspectionsAndChecks.
  ///
  /// In en, this message translates to:
  /// **'Inspections & Checks'**
  String get inspectionsAndChecks;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by Entellix.no'**
  String get createdBy;

  /// No description provided for @howTo.
  ///
  /// In en, this message translates to:
  /// **'How to calculate'**
  String get howTo;

  /// No description provided for @howToDescription.
  ///
  /// In en, this message translates to:
  /// **'The unit is tonnes. Example: 0.2 = 200kg'**
  String get howToDescription;

  /// No description provided for @weightTh.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight'**
  String get weightTh;

  /// No description provided for @del.
  ///
  /// In en, this message translates to:
  /// **'parts'**
  String get del;

  /// No description provided for @medWLL.
  ///
  /// In en, this message translates to:
  /// **'WLL'**
  String get medWLL;

  /// No description provided for @togd.
  ///
  /// In en, this message translates to:
  /// **'to Ø'**
  String get togd;

  /// No description provided for @mm.
  ///
  /// In en, this message translates to:
  /// **'mm'**
  String get mm;

  /// No description provided for @tons.
  ///
  /// In en, this message translates to:
  /// **'tons'**
  String get tons;

  /// No description provided for @typeWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight'**
  String get typeWeight;

  /// No description provided for @unsymmetricLift.
  ///
  /// In en, this message translates to:
  /// **'Assymetric lift'**
  String get unsymmetricLift;

  /// No description provided for @pressResult.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get pressResult;

  /// No description provided for @folgendeU.
  ///
  /// In en, this message translates to:
  /// **'Recommended for {arg1} {arg2}'**
  String folgendeU(Object arg1, Object arg2);

  /// No description provided for @dailyInspection.
  ///
  /// In en, this message translates to:
  /// **'Daily Inspection'**
  String get dailyInspection;

  /// No description provided for @performedBy.
  ///
  /// In en, this message translates to:
  /// **'Performed by operator before startup'**
  String get performedBy;

  /// No description provided for @truckType.
  ///
  /// In en, this message translates to:
  /// **'Truck Type'**
  String get truckType;

  /// No description provided for @truckNumber.
  ///
  /// In en, this message translates to:
  /// **'Truck Number'**
  String get truckNumber;

  /// No description provided for @weekNumber.
  ///
  /// In en, this message translates to:
  /// **'Week No.'**
  String get weekNumber;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get work;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @sendInspection.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get sendInspection;

  /// No description provided for @backToForm.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backToForm;

  /// No description provided for @abnormalConditions.
  ///
  /// In en, this message translates to:
  /// **'REPORT ABNORMAL CONDITIONS TO SUPERVISOR'**
  String get abnormalConditions;

  /// No description provided for @damageDescription.
  ///
  /// In en, this message translates to:
  /// **'Damage/Defects:'**
  String get damageDescription;

  /// No description provided for @describeDamage.
  ///
  /// In en, this message translates to:
  /// **'Describe damages'**
  String get describeDamage;

  /// No description provided for @repairDescription.
  ///
  /// In en, this message translates to:
  /// **'Repairs:'**
  String get repairDescription;

  /// No description provided for @describeRepairs.
  ///
  /// In en, this message translates to:
  /// **'Describe repairs'**
  String get describeRepairs;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @noneReported.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneReported;

  /// No description provided for @archiveNote.
  ///
  /// In en, this message translates to:
  /// **'Archive for 3 years'**
  String get archiveNote;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @dailyChecksCatMotorChassis.
  ///
  /// In en, this message translates to:
  /// **'Engine/Chassis'**
  String get dailyChecksCatMotorChassis;

  /// No description provided for @dailyChecksCatElectricTruck.
  ///
  /// In en, this message translates to:
  /// **'Electric Truck'**
  String get dailyChecksCatElectricTruck;

  /// No description provided for @dailyChecksCatWheels.
  ///
  /// In en, this message translates to:
  /// **'Wheels'**
  String get dailyChecksCatWheels;

  /// No description provided for @dailyChecksCatSafetyEquipment.
  ///
  /// In en, this message translates to:
  /// **'Safety Equipment'**
  String get dailyChecksCatSafetyEquipment;

  /// No description provided for @dailyChecksCatAdditionalEquipment.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get dailyChecksCatAdditionalEquipment;

  /// No description provided for @dailyChecksCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dailyChecksCatOther;

  /// No description provided for @dailyChecksCatCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get dailyChecksCatCleaning;

  /// No description provided for @selectEquipment.
  ///
  /// In en, this message translates to:
  /// **'Select equipment'**
  String get selectEquipment;

  /// No description provided for @dailyChecksTaskCheckDieselLevel.
  ///
  /// In en, this message translates to:
  /// **'Check diesel'**
  String get dailyChecksTaskCheckDieselLevel;

  /// No description provided for @dailyChecksTaskCheckCoolantLevel.
  ///
  /// In en, this message translates to:
  /// **'Check coolant'**
  String get dailyChecksTaskCheckCoolantLevel;

  /// No description provided for @dailyChecksTaskCheckEngineOilLevel.
  ///
  /// In en, this message translates to:
  /// **'Check engine oil'**
  String get dailyChecksTaskCheckEngineOilLevel;

  /// No description provided for @dailyChecksTaskCheckGearboxOilLevel.
  ///
  /// In en, this message translates to:
  /// **'Check gearbox oil'**
  String get dailyChecksTaskCheckGearboxOilLevel;

  /// No description provided for @dailyChecksTaskCheckHydraulicOilLevel.
  ///
  /// In en, this message translates to:
  /// **'Check hydraulic oil'**
  String get dailyChecksTaskCheckHydraulicOilLevel;

  /// No description provided for @dailyChecksTaskCheckRefillWasherFluid.
  ///
  /// In en, this message translates to:
  /// **'Check washer fluid'**
  String get dailyChecksTaskCheckRefillWasherFluid;

  /// No description provided for @dailyChecksTaskCheckStarterBattery.
  ///
  /// In en, this message translates to:
  /// **'Check battery'**
  String get dailyChecksTaskCheckStarterBattery;

  /// No description provided for @dailyChecksTaskCheckBatteryElectric.
  ///
  /// In en, this message translates to:
  /// **'Check battery (electric)'**
  String get dailyChecksTaskCheckBatteryElectric;

  /// No description provided for @dailyChecksTaskInspectTiresRimsBolts.
  ///
  /// In en, this message translates to:
  /// **'Inspect tires/rims'**
  String get dailyChecksTaskInspectTiresRimsBolts;

  /// No description provided for @dailyChecksTaskCheckLightsSoundMirrors.
  ///
  /// In en, this message translates to:
  /// **'Check lights/sound'**
  String get dailyChecksTaskCheckLightsSoundMirrors;

  /// No description provided for @dailyChecksTaskTestBrakes.
  ///
  /// In en, this message translates to:
  /// **'Test brakes'**
  String get dailyChecksTaskTestBrakes;

  /// No description provided for @dailyChecksTaskTestSteeringHoisting.
  ///
  /// In en, this message translates to:
  /// **'Test steering'**
  String get dailyChecksTaskTestSteeringHoisting;

  /// No description provided for @dailyChecksTaskCheckLeaksDamage.
  ///
  /// In en, this message translates to:
  /// **'Check for leaks'**
  String get dailyChecksTaskCheckLeaksDamage;

  /// No description provided for @dailyChecksTaskCheckFireExtinguisherFirstAid.
  ///
  /// In en, this message translates to:
  /// **'Check safety equipment'**
  String get dailyChecksTaskCheckFireExtinguisherFirstAid;

  /// No description provided for @dailyChecksTaskCheckAdditionalEquipmentManual.
  ///
  /// In en, this message translates to:
  /// **'Check attachments'**
  String get dailyChecksTaskCheckAdditionalEquipmentManual;

  /// No description provided for @dailyChecksTaskCheckLiftingChainForks.
  ///
  /// In en, this message translates to:
  /// **'Check forks/chain'**
  String get dailyChecksTaskCheckLiftingChainForks;

  /// No description provided for @dailyChecksTaskCheckTruckCleanliness.
  ///
  /// In en, this message translates to:
  /// **'Check cleanliness'**
  String get dailyChecksTaskCheckTruckCleanliness;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @withWeight.
  ///
  /// In en, this message translates to:
  /// **'with weight'**
  String get withWeight;

  /// No description provided for @ton.
  ///
  /// In en, this message translates to:
  /// **'tons'**
  String get ton;

  /// No description provided for @med.
  ///
  /// In en, this message translates to:
  /// **'with'**
  String get med;

  /// No description provided for @deleteLift.
  ///
  /// In en, this message translates to:
  /// **'Delete this lift?'**
  String get deleteLift;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight: '**
  String get weightLabel;

  /// No description provided for @equipmentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment Type: '**
  String get equipmentTypeLabel;

  /// No description provided for @dateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date/Time: '**
  String get dateTimeLabel;

  /// No description provided for @symmetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Symmetry: '**
  String get symmetryLabel;

  /// No description provided for @unsymmetricStatus.
  ///
  /// In en, this message translates to:
  /// **'Unsymmetric'**
  String get unsymmetricStatus;

  /// No description provided for @symmetricStatus.
  ///
  /// In en, this message translates to:
  /// **'Symmetric'**
  String get symmetricStatus;

  /// No description provided for @calculatedDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculated Details:'**
  String get calculatedDetailsTitle;

  /// No description provided for @errorFetchingLifts.
  ///
  /// In en, this message translates to:
  /// **'Error fetching saved lifts:'**
  String get errorFetchingLifts;

  /// No description provided for @stackTraceLabel.
  ///
  /// In en, this message translates to:
  /// **'Stack Trace'**
  String get stackTraceLabel;

  /// No description provided for @noLiftsSavedYet.
  ///
  /// In en, this message translates to:
  /// **'No lifts have been saved yet.'**
  String get noLiftsSavedYet;

  /// No description provided for @unexpectedState.
  ///
  /// In en, this message translates to:
  /// **'Unexpected state encountered.'**
  String get unexpectedState;

  /// Title for the lift deletion confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Lift'**
  String get deleteLiftConfirmationTitle;

  /// No description provided for @deleteLiftConfirmationContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the lift \'{liftName}\'?'**
  String deleteLiftConfirmationContent(Object liftName);

  /// No description provided for @formPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection Preview'**
  String get formPreviewTitle;

  /// No description provided for @formButtonPreviewInspection.
  ///
  /// In en, this message translates to:
  /// **'Preview Inspection'**
  String get formButtonPreviewInspection;

  /// No description provided for @formButtonBackToForm.
  ///
  /// In en, this message translates to:
  /// **'Back to Form'**
  String get formButtonBackToForm;

  /// No description provided for @formSendOptionEmail.
  ///
  /// In en, this message translates to:
  /// **'Send via Email App'**
  String get formSendOptionEmail;

  /// No description provided for @formSendOptionNativeMail.
  ///
  /// In en, this message translates to:
  /// **'Send via Native Mail Client'**
  String get formSendOptionNativeMail;

  /// No description provided for @formButtonSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get formButtonSend;

  /// No description provided for @emailNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'No email app'**
  String get emailNotConfigured;

  /// No description provided for @emailContent.
  ///
  /// In en, this message translates to:
  /// **'Email content:'**
  String get emailContent;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copiedToClipboard;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyToClipboard;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorLaunching.
  ///
  /// In en, this message translates to:
  /// **'Error launching'**
  String get errorLaunching;

  /// No description provided for @couldNotLaunchEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Can\'t open email'**
  String get couldNotLaunchEmailApp;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @straightLift.
  ///
  /// In en, this message translates to:
  /// **'Straight Lift'**
  String get straightLift;

  /// No description provided for @snareLift.
  ///
  /// In en, this message translates to:
  /// **'Choked Lift'**
  String get snareLift;

  /// No description provided for @uLift.
  ///
  /// In en, this message translates to:
  /// **'U-Lift'**
  String get uLift;

  /// No description provided for @ulv.
  ///
  /// In en, this message translates to:
  /// **'U-Lift Angle'**
  String get ulv;

  /// No description provided for @straight.
  ///
  /// In en, this message translates to:
  /// **'Direct (15-45)'**
  String get straight;

  /// No description provided for @snare.
  ///
  /// In en, this message translates to:
  /// **'Choked (15-45)'**
  String get snare;

  /// No description provided for @direct4560.
  ///
  /// In en, this message translates to:
  /// **'Direct (46-60)'**
  String get direct4560;

  /// No description provided for @snare4560.
  ///
  /// In en, this message translates to:
  /// **'Choked (46-60)'**
  String get snare4560;

  /// No description provided for @direct3.
  ///
  /// In en, this message translates to:
  /// **'Direct (15-45)'**
  String get direct3;

  /// No description provided for @snare3.
  ///
  /// In en, this message translates to:
  /// **'Choked (15-45)'**
  String get snare3;

  /// No description provided for @direct32.
  ///
  /// In en, this message translates to:
  /// **'Direct (46-60)'**
  String get direct32;

  /// No description provided for @snare32.
  ///
  /// In en, this message translates to:
  /// **'Choked (46-60)'**
  String get snare32;

  /// No description provided for @truckInspectionForm.
  ///
  /// In en, this message translates to:
  /// **'Type control'**
  String get truckInspectionForm;

  /// No description provided for @dailyTruckInspection.
  ///
  /// In en, this message translates to:
  /// **'DAILY TRUCK INSPECTION'**
  String get dailyTruckInspection;

  /// No description provided for @driverName.
  ///
  /// In en, this message translates to:
  /// **'Driver Name'**
  String get driverName;

  /// No description provided for @odometerReading.
  ///
  /// In en, this message translates to:
  /// **'Odometer Reading'**
  String get odometerReading;

  /// No description provided for @inspectionItems.
  ///
  /// In en, this message translates to:
  /// **'Inspection Items (Check if OK)'**
  String get inspectionItems;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @submitInspection.
  ///
  /// In en, this message translates to:
  /// **'Submit Inspection'**
  String get submitInspection;

  /// No description provided for @lightsInspection.
  ///
  /// In en, this message translates to:
  /// **'Lights (head, tail, brake, turn signals)'**
  String get lightsInspection;

  /// No description provided for @tiresInspection.
  ///
  /// In en, this message translates to:
  /// **'Tires (pressure, tread, damage)'**
  String get tiresInspection;

  /// No description provided for @brakesInspection.
  ///
  /// In en, this message translates to:
  /// **'Brakes (parking and service)'**
  String get brakesInspection;

  /// No description provided for @fluidsInspection.
  ///
  /// In en, this message translates to:
  /// **'Fluid levels (oil, coolant, brake, power steering)'**
  String get fluidsInspection;

  /// No description provided for @hornInspection.
  ///
  /// In en, this message translates to:
  /// **'Horn'**
  String get hornInspection;

  /// No description provided for @windshieldInspection.
  ///
  /// In en, this message translates to:
  /// **'Windshield and wipers'**
  String get windshieldInspection;

  /// No description provided for @mirrorsInspection.
  ///
  /// In en, this message translates to:
  /// **'Mirrors'**
  String get mirrorsInspection;

  /// No description provided for @seatBeltsInspection.
  ///
  /// In en, this message translates to:
  /// **'Seat belts'**
  String get seatBeltsInspection;

  /// No description provided for @emergencyEquipmentInspection.
  ///
  /// In en, this message translates to:
  /// **'Emergency equipment (fire extinguisher, triangles)'**
  String get emergencyEquipmentInspection;

  /// No description provided for @leaksInspection.
  ///
  /// In en, this message translates to:
  /// **'No leaks (oil, fuel, coolant)'**
  String get leaksInspection;

  /// No description provided for @steeringInspection.
  ///
  /// In en, this message translates to:
  /// **'Steering system'**
  String get steeringInspection;

  /// No description provided for @suspensionInspection.
  ///
  /// In en, this message translates to:
  /// **'Suspension system'**
  String get suspensionInspection;

  /// No description provided for @exhaustInspection.
  ///
  /// In en, this message translates to:
  /// **'Exhaust system'**
  String get exhaustInspection;

  /// No description provided for @couplingInspection.
  ///
  /// In en, this message translates to:
  /// **'Coupling devices'**
  String get couplingInspection;

  /// No description provided for @cargoInspection.
  ///
  /// In en, this message translates to:
  /// **'Cargo securement'**
  String get cargoInspection;

  /// No description provided for @fiberSling.
  ///
  /// In en, this message translates to:
  /// **'Fiber sling'**
  String get fiberSling;

  /// No description provided for @chain80.
  ///
  /// In en, this message translates to:
  /// **'Chain (Grade 80)'**
  String get chain80;

  /// No description provided for @chain100.
  ///
  /// In en, this message translates to:
  /// **'Chain (Grade 100)'**
  String get chain100;

  /// No description provided for @steelRope.
  ///
  /// In en, this message translates to:
  /// **'Steel rope (FC)'**
  String get steelRope;

  /// No description provided for @steelRopeIWC.
  ///
  /// In en, this message translates to:
  /// **'Steel rope (IWRC)'**
  String get steelRopeIWC;

  /// No description provided for @enterDriverName.
  ///
  /// In en, this message translates to:
  /// **'Please enter driver name'**
  String get enterDriverName;

  /// No description provided for @enterTruckNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter truck number'**
  String get enterTruckNumber;

  /// No description provided for @enterOdometer.
  ///
  /// In en, this message translates to:
  /// **'Please enter odometer reading'**
  String get enterOdometer;

  /// No description provided for @incompleteInspection.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Inspection'**
  String get incompleteInspection;

  /// No description provided for @verifyItems.
  ///
  /// In en, this message translates to:
  /// **'Please verify all inspection items before submitting.'**
  String get verifyItems;

  /// No description provided for @inspectionSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Inspection Submitted'**
  String get inspectionSubmitted;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for completing the inspection.'**
  String get thankYou;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any additional notes or defects found...'**
  String get notesHint;

  /// No description provided for @liftNr.
  ///
  /// In en, this message translates to:
  /// **'Lift No.'**
  String get liftNr;

  /// No description provided for @typeControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Type Control'**
  String get typeControlTitle;

  /// No description provided for @forkliftTypeTrainingHeader.
  ///
  /// In en, this message translates to:
  /// **'Forklift Type Training'**
  String get forkliftTypeTrainingHeader;

  /// No description provided for @regulationsSubHeader.
  ///
  /// In en, this message translates to:
  /// **'In accordance with the Working Environment Act § 10-4 and the Regulations concerning Performance of Work and Use of Work Equipment § 13, 57'**
  String get regulationsSubHeader;

  /// No description provided for @trainingInformationSection.
  ///
  /// In en, this message translates to:
  /// **'Training Information'**
  String get trainingInformationSection;

  /// No description provided for @truckTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Truck Type'**
  String get truckTypeLabel;

  /// No description provided for @truckNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Truck Number'**
  String get truckNumberLabel;

  /// No description provided for @trainerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainer Name'**
  String get trainerNameLabel;

  /// No description provided for @traineeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Trainee Name'**
  String get traineeNameLabel;

  /// No description provided for @companyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companyLabel;

  /// No description provided for @trainingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Date:'**
  String get trainingDateLabel;

  /// No description provided for @trainingChecklistSection.
  ///
  /// In en, this message translates to:
  /// **'Training Checklist'**
  String get trainingChecklistSection;

  /// No description provided for @additionalNotesSection.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotesSection;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any additional notes about the training...'**
  String get additionalNotesHint;

  /// No description provided for @submitTrainingButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Training Record'**
  String get submitTrainingButton;

  /// No description provided for @requiredFieldValidator.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldValidator;

  /// No description provided for @trainingRecordedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Recorded'**
  String get trainingRecordedDialogTitle;

  /// No description provided for @trainingRecordedDialogContent.
  ///
  /// In en, this message translates to:
  /// **'The training record has been successfully saved.'**
  String get trainingRecordedDialogContent;

  /// No description provided for @commentsReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Comments/Reason'**
  String get commentsReasonLabel;

  /// No description provided for @optionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get optionYes;

  /// No description provided for @optionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get optionNo;

  /// No description provided for @optionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get optionDone;

  /// No description provided for @optionNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'Not applicable'**
  String get optionNotApplicable;

  /// No description provided for @checklistItemLicenseAvailable.
  ///
  /// In en, this message translates to:
  /// **'License available'**
  String get checklistItemLicenseAvailable;

  /// No description provided for @checklistItemInstructionManualRead.
  ///
  /// In en, this message translates to:
  /// **'Instruction manual read'**
  String get checklistItemInstructionManualRead;

  /// No description provided for @checklistItemExplainMainParts.
  ///
  /// In en, this message translates to:
  /// **'Explain main parts'**
  String get checklistItemExplainMainParts;

  /// No description provided for @checklistItemExplainLevers.
  ///
  /// In en, this message translates to:
  /// **'Explain levers'**
  String get checklistItemExplainLevers;

  /// No description provided for @checklistItemHowToStart.
  ///
  /// In en, this message translates to:
  /// **'How to start'**
  String get checklistItemHowToStart;

  /// No description provided for @checklistItemExplainTilt.
  ///
  /// In en, this message translates to:
  /// **'Explain tilt'**
  String get checklistItemExplainTilt;

  /// No description provided for @checklistItemShowPedals.
  ///
  /// In en, this message translates to:
  /// **'Show pedals'**
  String get checklistItemShowPedals;

  /// No description provided for @checklistItemExplainMarkings.
  ///
  /// In en, this message translates to:
  /// **'Explain markings'**
  String get checklistItemExplainMarkings;

  /// No description provided for @checklistItemExplainLiftingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Explain lifting capacity'**
  String get checklistItemExplainLiftingCapacity;

  /// No description provided for @checklistItemExplainLiftingDiagram.
  ///
  /// In en, this message translates to:
  /// **'Explain lifting diagram'**
  String get checklistItemExplainLiftingDiagram;

  /// No description provided for @checklistItemExplainDrivingHeight.
  ///
  /// In en, this message translates to:
  /// **'Explain driving height'**
  String get checklistItemExplainDrivingHeight;

  /// No description provided for @checklistItemExplainMaxLiftingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Explain max lifting capacity'**
  String get checklistItemExplainMaxLiftingCapacity;

  /// No description provided for @checklistItemExplainCenterOfGravity.
  ///
  /// In en, this message translates to:
  /// **'Explain center of gravity'**
  String get checklistItemExplainCenterOfGravity;

  /// No description provided for @checklistItemShowDangerousAreas.
  ///
  /// In en, this message translates to:
  /// **'Show dangerous areas'**
  String get checklistItemShowDangerousAreas;

  /// No description provided for @checklistItemShowDailyControl.
  ///
  /// In en, this message translates to:
  /// **'Show daily control'**
  String get checklistItemShowDailyControl;

  /// No description provided for @checklistItemShowTruckCharging.
  ///
  /// In en, this message translates to:
  /// **'Show truck charging'**
  String get checklistItemShowTruckCharging;

  /// No description provided for @checklistItemShowBatteryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Show battery maintenance'**
  String get checklistItemShowBatteryMaintenance;

  /// No description provided for @checklistItemShowProperParking.
  ///
  /// In en, this message translates to:
  /// **'Show proper parking'**
  String get checklistItemShowProperParking;

  /// No description provided for @checklistItemShowCorrectGoodsHandling.
  ///
  /// In en, this message translates to:
  /// **'Show correct goods handling'**
  String get checklistItemShowCorrectGoodsHandling;

  /// No description provided for @checklistItemShowAdditionalEquipment.
  ///
  /// In en, this message translates to:
  /// **'Show additional equipment'**
  String get checklistItemShowAdditionalEquipment;

  /// No description provided for @checklistItemShowDocumentationStorage.
  ///
  /// In en, this message translates to:
  /// **'Show documentation storage'**
  String get checklistItemShowDocumentationStorage;

  /// No description provided for @dailyCheckForkliftInspectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check'**
  String get dailyCheckForkliftInspectionTitle;

  /// No description provided for @dailyCheckCraneInspectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Crane Daily Check'**
  String get dailyCheckCraneInspectionTitle;

  /// No description provided for @dailyCheckForkliftLabel.
  ///
  /// In en, this message translates to:
  /// **'Forklift'**
  String get dailyCheckForkliftLabel;

  /// No description provided for @dailyCheckCraneLabel.
  ///
  /// In en, this message translates to:
  /// **'Crane'**
  String get dailyCheckCraneLabel;

  /// No description provided for @formSectionContactInformation.
  ///
  /// In en, this message translates to:
  /// **'1. Contact Information'**
  String get formSectionContactInformation;

  /// No description provided for @formSectionOperatorInformation.
  ///
  /// In en, this message translates to:
  /// **'1. Operator Information'**
  String get formSectionOperatorInformation;

  /// No description provided for @formFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get formFieldName;

  /// No description provided for @formFieldOperatorName.
  ///
  /// In en, this message translates to:
  /// **'Operator Name'**
  String get formFieldOperatorName;

  /// No description provided for @formFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get formFieldRequired;

  /// No description provided for @formFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get formFieldEmail;

  /// No description provided for @formFieldPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get formFieldPhoneNumber;

  /// No description provided for @formFieldBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get formFieldBirthdate;

  /// No description provided for @formFieldForkliftModel.
  ///
  /// In en, this message translates to:
  /// **'Forklift Model'**
  String get formFieldForkliftModel;

  /// No description provided for @formSectionCertification.
  ///
  /// In en, this message translates to:
  /// **'2. Certification'**
  String get formSectionCertification;

  /// No description provided for @formSectionCertificationAndManuals.
  ///
  /// In en, this message translates to:
  /// **'3. Certification & Manuals'**
  String get formSectionCertificationAndManuals;

  /// No description provided for @formQuestionCertificateOfCompetence.
  ///
  /// In en, this message translates to:
  /// **'Do you have a certificate of competence?'**
  String get formQuestionCertificateOfCompetence;

  /// No description provided for @formQuestionCertificateOfCompetenceCrane.
  ///
  /// In en, this message translates to:
  /// **'Do you have a certificate of competence for this crane type?'**
  String get formQuestionCertificateOfCompetenceCrane;

  /// No description provided for @formAnswerYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get formAnswerYes;

  /// No description provided for @formAnswerNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get formAnswerNo;

  /// No description provided for @formQuestionInstructionManualAvailable.
  ///
  /// In en, this message translates to:
  /// **'Is the instruction manual available?'**
  String get formQuestionInstructionManualAvailable;

  /// No description provided for @formSectionInspectionChecklist.
  ///
  /// In en, this message translates to:
  /// **'Inspection Checklist'**
  String get formSectionInspectionChecklist;

  /// No description provided for @formSectionCraneInspectionChecklist.
  ///
  /// In en, this message translates to:
  /// **'Crane Inspection Checklist'**
  String get formSectionCraneInspectionChecklist;

  /// No description provided for @forkliftChecklistItemMainParts.
  ///
  /// In en, this message translates to:
  /// **'Check the truck\'s main parts'**
  String get forkliftChecklistItemMainParts;

  /// No description provided for @forkliftChecklistItemLeversSwitches.
  ///
  /// In en, this message translates to:
  /// **'Check levers/switches/joystick'**
  String get forkliftChecklistItemLeversSwitches;

  /// No description provided for @forkliftChecklistItemStartTruck.
  ///
  /// In en, this message translates to:
  /// **'Start the truck'**
  String get forkliftChecklistItemStartTruck;

  /// No description provided for @forkliftChecklistItemPedalsHandbrake.
  ///
  /// In en, this message translates to:
  /// **'Check pedals and handbrake'**
  String get forkliftChecklistItemPedalsHandbrake;

  /// No description provided for @forkliftChecklistItemLiftingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Explain lifting capacity/diagram'**
  String get forkliftChecklistItemLiftingCapacity;

  /// No description provided for @forkliftChecklistItemCenterOfGravity.
  ///
  /// In en, this message translates to:
  /// **'Explain center of gravity distance'**
  String get forkliftChecklistItemCenterOfGravity;

  /// No description provided for @forkliftChecklistItemMaxLiftingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Explain max lifting capacity/reduction'**
  String get forkliftChecklistItemMaxLiftingCapacity;

  /// No description provided for @forkliftChecklistItemDrivingHeightMast.
  ///
  /// In en, this message translates to:
  /// **'Check driving height/mast'**
  String get forkliftChecklistItemDrivingHeightMast;

  /// No description provided for @forkliftChecklistItemSoundLightsMirrors.
  ///
  /// In en, this message translates to:
  /// **'Check sound, lights and mirrors'**
  String get forkliftChecklistItemSoundLightsMirrors;

  /// No description provided for @forkliftChecklistItemLeaksDamageHydraulic.
  ///
  /// In en, this message translates to:
  /// **'Check for leaks/damage (Hydraulic system)'**
  String get forkliftChecklistItemLeaksDamageHydraulic;

  /// No description provided for @forkliftChecklistItemLiftingChainForks.
  ///
  /// In en, this message translates to:
  /// **'Check lifting chain and forks'**
  String get forkliftChecklistItemLiftingChainForks;

  /// No description provided for @forkliftChecklistItemTiresRimsBolts.
  ///
  /// In en, this message translates to:
  /// **'Check tires, rims and wheel bolts'**
  String get forkliftChecklistItemTiresRimsBolts;

  /// No description provided for @forkliftChecklistItemRiskAssessment.
  ///
  /// In en, this message translates to:
  /// **'Risk assessment of dangerous areas'**
  String get forkliftChecklistItemRiskAssessment;

  /// No description provided for @forkliftChecklistItemFuelBattery.
  ///
  /// In en, this message translates to:
  /// **'Check fuel level/battery charging'**
  String get forkliftChecklistItemFuelBattery;

  /// No description provided for @forkliftChecklistItemBatteryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Battery maintenance check'**
  String get forkliftChecklistItemBatteryMaintenance;

  /// No description provided for @forkliftChecklistItemCorrectParking.
  ///
  /// In en, this message translates to:
  /// **'Check correct parking/forks position'**
  String get forkliftChecklistItemCorrectParking;

  /// No description provided for @forkliftChecklistItemPalletHandling.
  ///
  /// In en, this message translates to:
  /// **'Demonstrate correct pallet handling'**
  String get forkliftChecklistItemPalletHandling;

  /// No description provided for @forkliftChecklistItemForkSpreader.
  ///
  /// In en, this message translates to:
  /// **'Check fork spreader/side offset'**
  String get forkliftChecklistItemForkSpreader;

  /// No description provided for @formSectionImprovements.
  ///
  /// In en, this message translates to:
  /// **'Improvements/Remarks'**
  String get formSectionImprovements;

  /// No description provided for @formSectionImprovementsRemarks.
  ///
  /// In en, this message translates to:
  /// **'Improvements/Remarks'**
  String get formSectionImprovementsRemarks;

  /// No description provided for @formHintImprovementsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Enter any improvements needed...'**
  String get formHintImprovementsNeeded;

  /// No description provided for @formHintImprovementsRemarks.
  ///
  /// In en, this message translates to:
  /// **'Enter any improvements or remarks...'**
  String get formHintImprovementsRemarks;

  /// No description provided for @formButtonSubmitInspection.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT INSPECTION'**
  String get formButtonSubmitInspection;

  /// No description provided for @formButtonSubmitCraneInspection.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT CRANE INSPECTION'**
  String get formButtonSubmitCraneInspection;

  /// No description provided for @formSnackbarPleaseCompleteFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields.'**
  String get formSnackbarPleaseCompleteFields;

  /// No description provided for @formSnackbarForkliftSubmissionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Forklift inspection submitted successfully'**
  String get formSnackbarForkliftSubmissionSuccess;

  /// No description provided for @formSnackbarCraneSubmissionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Crane inspection submitted successfully'**
  String get formSnackbarCraneSubmissionSuccess;

  /// No description provided for @formSectionCraneDetails.
  ///
  /// In en, this message translates to:
  /// **'2. Crane Details'**
  String get formSectionCraneDetails;

  /// No description provided for @formFieldCraneModel.
  ///
  /// In en, this message translates to:
  /// **'Crane Model'**
  String get formFieldCraneModel;

  /// No description provided for @formFieldCraneID.
  ///
  /// In en, this message translates to:
  /// **'Crane ID'**
  String get formFieldCraneID;

  /// No description provided for @craneChecklistItemHoistTrolley.
  ///
  /// In en, this message translates to:
  /// **'Inspect Hoist/Trolley mechanisms'**
  String get craneChecklistItemHoistTrolley;

  /// No description provided for @craneChecklistItemRopesChains.
  ///
  /// In en, this message translates to:
  /// **'Check Wire Ropes/Chains for wear/damage'**
  String get craneChecklistItemRopesChains;

  /// No description provided for @craneChecklistItemLimitSwitches.
  ///
  /// In en, this message translates to:
  /// **'Test Upper and Lower Limit Switches'**
  String get craneChecklistItemLimitSwitches;

  /// No description provided for @craneChecklistItemLoadChart.
  ///
  /// In en, this message translates to:
  /// **'Verify Load Chart is visible and legible'**
  String get craneChecklistItemLoadChart;

  /// No description provided for @craneChecklistItemHooksLatches.
  ///
  /// In en, this message translates to:
  /// **'Inspect Hooks and Safety Latches'**
  String get craneChecklistItemHooksLatches;

  /// No description provided for @craneChecklistItemOutriggers.
  ///
  /// In en, this message translates to:
  /// **'Check Outriggers/Stabilizers (if applicable)'**
  String get craneChecklistItemOutriggers;

  /// No description provided for @craneChecklistItemEmergencyStop.
  ///
  /// In en, this message translates to:
  /// **'Test Emergency Stop functionality'**
  String get craneChecklistItemEmergencyStop;

  /// No description provided for @craneChecklistItemControlSystem.
  ///
  /// In en, this message translates to:
  /// **'Inspect Control System (pendants, remotes)'**
  String get craneChecklistItemControlSystem;

  /// No description provided for @craneChecklistItemStructuralComponents.
  ///
  /// In en, this message translates to:
  /// **'Visual check of Structural Components (boom, jib)'**
  String get craneChecklistItemStructuralComponents;

  /// No description provided for @craneChecklistItemFluidLevels.
  ///
  /// In en, this message translates to:
  /// **'Check Fluid Levels (hydraulic, oil, coolant)'**
  String get craneChecklistItemFluidLevels;

  /// No description provided for @craneChecklistItemSlewingMechanism.
  ///
  /// In en, this message translates to:
  /// **'Verify Slewing Ring/Mechanism'**
  String get craneChecklistItemSlewingMechanism;

  /// No description provided for @craneChecklistItemBrakes.
  ///
  /// In en, this message translates to:
  /// **'Inspect Brakes (hoist, travel, slew)'**
  String get craneChecklistItemBrakes;

  /// No description provided for @craneChecklistItemElectricalSystems.
  ///
  /// In en, this message translates to:
  /// **'Check Electrical Systems and Wiring'**
  String get craneChecklistItemElectricalSystems;

  /// No description provided for @craneChecklistItemWarningDevices.
  ///
  /// In en, this message translates to:
  /// **'Ensure Warning Devices (horn, lights) are functional'**
  String get craneChecklistItemWarningDevices;

  /// No description provided for @craneChecklistItemLogsReview.
  ///
  /// In en, this message translates to:
  /// **'Review Maintenance and Inspection Logs'**
  String get craneChecklistItemLogsReview;

  /// No description provided for @formFieldRequiredValidator.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get formFieldRequiredValidator;

  /// No description provided for @formButtonSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save Progress'**
  String get formButtonSaveProgress;

  /// No description provided for @formButtonClearForm.
  ///
  /// In en, this message translates to:
  /// **'Clear Form'**
  String get formButtonClearForm;

  /// No description provided for @formSnackbarProgressSaved.
  ///
  /// In en, this message translates to:
  /// **'Form progress saved.'**
  String get formSnackbarProgressSaved;

  /// No description provided for @formSnackbarProgressLoaded.
  ///
  /// In en, this message translates to:
  /// **'Form progress loaded.'**
  String get formSnackbarProgressLoaded;

  /// No description provided for @formSnackbarFormCleared.
  ///
  /// In en, this message translates to:
  /// **'Form cleared.'**
  String get formSnackbarFormCleared;

  /// No description provided for @formSnackbarEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Inspection report sent successfully!'**
  String get formSnackbarEmailSent;

  /// No description provided for @formSnackbarEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send email: {error}'**
  String formSnackbarEmailFailed(String error);

  /// No description provided for @emailSubjectForkliftInspection.
  ///
  /// In en, this message translates to:
  /// **'Forklift Inspection Report - {date}'**
  String emailSubjectForkliftInspection(String date);

  /// No description provided for @emailSubjectCraneInspection.
  ///
  /// In en, this message translates to:
  /// **'Crane Inspection Report - {date}'**
  String emailSubjectCraneInspection(String date);

  /// No description provided for @emailBodyPreamble.
  ///
  /// In en, this message translates to:
  /// **'Daily Equipment Inspection Report'**
  String get emailBodyPreamble;

  /// No description provided for @emailFieldOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator Name'**
  String get emailFieldOperator;

  /// No description provided for @emailFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailFieldEmail;

  /// No description provided for @emailFieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get emailFieldPhone;

  /// No description provided for @emailFieldBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get emailFieldBirthdate;

  /// No description provided for @emailFieldModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get emailFieldModel;

  /// No description provided for @emailFieldID.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get emailFieldID;

  /// No description provided for @emailFieldCertificate.
  ///
  /// In en, this message translates to:
  /// **'Has Certificate'**
  String get emailFieldCertificate;

  /// No description provided for @emailFieldManual.
  ///
  /// In en, this message translates to:
  /// **'Has Manual'**
  String get emailFieldManual;

  /// No description provided for @emailFieldChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get emailFieldChecklist;

  /// No description provided for @emailFieldImprovements.
  ///
  /// In en, this message translates to:
  /// **'Improvements/Remarks'**
  String get emailFieldImprovements;

  /// No description provided for @emailFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get emailFieldDate;

  /// No description provided for @emailChecklistItemStatusChecked.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get emailChecklistItemStatusChecked;

  /// No description provided for @emailChecklistItemStatusUnchecked.
  ///
  /// In en, this message translates to:
  /// **'Not Checked'**
  String get emailChecklistItemStatusUnchecked;

  /// No description provided for @customImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Image'**
  String get customImageLabel;

  /// No description provided for @addImageOptional.
  ///
  /// In en, this message translates to:
  /// **'Add Optional Image'**
  String get addImageOptional;

  /// No description provided for @changeImageOptional.
  ///
  /// In en, this message translates to:
  /// **'Change Optional Image'**
  String get changeImageOptional;

  /// No description provided for @previousLiftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Previous Lifts'**
  String get previousLiftsTitle;

  /// No description provided for @noSavedLifts.
  ///
  /// In en, this message translates to:
  /// **'No saved lifts yet'**
  String get noSavedLifts;

  /// No description provided for @partsLabel.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get partsLabel;

  /// No description provided for @wllLabel.
  ///
  /// In en, this message translates to:
  /// **'WLL'**
  String get wllLabel;

  /// No description provided for @diameterLabel.
  ///
  /// In en, this message translates to:
  /// **'Diameter'**
  String get diameterLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @errorLoadingLifts.
  ///
  /// In en, this message translates to:
  /// **'Error loading lifts'**
  String get errorLoadingLifts;

  /// No description provided for @saveLiftButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Lift'**
  String get saveLiftButtonLabel;

  /// No description provided for @selectImageSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSourceTitle;

  /// No description provided for @cameraButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraButtonLabel;

  /// No description provided for @galleryButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryButtonLabel;

  /// No description provided for @imagePickerError.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get imagePickerError;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @liftSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Lift saved successfully'**
  String get liftSavedSuccessfully;

  /// No description provided for @formulaPrefix.
  ///
  /// In en, this message translates to:
  /// **'Formula: '**
  String get formulaPrefix;

  /// No description provided for @hydraulicCalculator.
  ///
  /// In en, this message translates to:
  /// **'Hydraulics'**
  String get hydraulicCalculator;

  /// No description provided for @cylinderCalculator.
  ///
  /// In en, this message translates to:
  /// **'Cylinder Calculator'**
  String get cylinderCalculator;

  /// No description provided for @motorCalculator.
  ///
  /// In en, this message translates to:
  /// **'Motor Calculator'**
  String get motorCalculator;

  /// No description provided for @pumpCalculator.
  ///
  /// In en, this message translates to:
  /// **'Pump Calculator'**
  String get pumpCalculator;

  /// No description provided for @pressureDropCalculator.
  ///
  /// In en, this message translates to:
  /// **'Pressure Drop Calculator'**
  String get pressureDropCalculator;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @pistonBoreDiameter.
  ///
  /// In en, this message translates to:
  /// **'Piston/Bore Diameter'**
  String get pistonBoreDiameter;

  /// No description provided for @rodDiameter.
  ///
  /// In en, this message translates to:
  /// **'Rod Diameter'**
  String get rodDiameter;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get pressure;

  /// No description provided for @oilFlow.
  ///
  /// In en, this message translates to:
  /// **'Oil Flow'**
  String get oilFlow;

  /// No description provided for @boreSideArea.
  ///
  /// In en, this message translates to:
  /// **'Bore Side Area'**
  String get boreSideArea;

  /// No description provided for @boreSideForce.
  ///
  /// In en, this message translates to:
  /// **'Bore Side Force'**
  String get boreSideForce;

  /// No description provided for @rodSideArea.
  ///
  /// In en, this message translates to:
  /// **'Rod Side Area'**
  String get rodSideArea;

  /// No description provided for @rodSideForce.
  ///
  /// In en, this message translates to:
  /// **'Rod Side Force'**
  String get rodSideForce;

  /// No description provided for @boreSideVelocity.
  ///
  /// In en, this message translates to:
  /// **'Bore Side Velocity'**
  String get boreSideVelocity;

  /// No description provided for @rodSideVelocity.
  ///
  /// In en, this message translates to:
  /// **'Rod Side Velocity'**
  String get rodSideVelocity;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @volumeFlowCalculatorDisplacementLabel.
  ///
  /// In en, this message translates to:
  /// **'Displacement (V)'**
  String get volumeFlowCalculatorDisplacementLabel;

  /// No description provided for @volumeFlow.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow'**
  String get volumeFlow;

  /// No description provided for @volumeFlowCalculatorRpmLabel.
  ///
  /// In en, this message translates to:
  /// **'Rotational Speed (n)'**
  String get volumeFlowCalculatorRpmLabel;

  /// No description provided for @torqueCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Torque (M)'**
  String get torqueCalculatorResultLabel;

  /// No description provided for @hydraulicPowerCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Power (P)'**
  String get hydraulicPowerCalculatorResultLabel;

  /// No description provided for @volumeFlowCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow (q)'**
  String get volumeFlowCalculatorResultLabel;

  /// No description provided for @oilSpeedCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed (v)'**
  String get oilSpeedCalculatorResultLabel;

  /// No description provided for @powerLossCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Power Loss from Flow & Pressure Drop'**
  String get powerLossCalculatorTitle;

  /// No description provided for @pressureDrop.
  ///
  /// In en, this message translates to:
  /// **'Pressure Drop'**
  String get pressureDrop;

  /// No description provided for @powerLoss.
  ///
  /// In en, this message translates to:
  /// **'Power Loss'**
  String get powerLoss;

  /// No description provided for @efficiencyCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get efficiencyCalculatorTitle;

  /// No description provided for @efficiencyCalculatorInputPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Input Power (P.tilf)'**
  String get efficiencyCalculatorInputPowerLabel;

  /// No description provided for @efficiencyCalculatorOutputPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Output Power (P.avg)'**
  String get efficiencyCalculatorOutputPowerLabel;

  /// No description provided for @efficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency (η)'**
  String get efficiency;

  /// No description provided for @forcePressureAreaCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Force from Pressure & Area'**
  String get forcePressureAreaCalculatorTitle;

  /// No description provided for @forcePressureAreaCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates force on a piston stem'**
  String get forcePressureAreaCalculatorDescription;

  /// No description provided for @forcePressureAreaCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Force Calculator'**
  String get forcePressureAreaCalculatorPageTitle;

  /// No description provided for @forcePressureAreaCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'F = p * A'**
  String get forcePressureAreaCalculatorFormula;

  /// No description provided for @forcePressureAreaCalculatorPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Pressure (p)'**
  String get forcePressureAreaCalculatorPressureLabel;

  /// No description provided for @forcePressureAreaCalculatorPressureUnit.
  ///
  /// In en, this message translates to:
  /// **'bar'**
  String get forcePressureAreaCalculatorPressureUnit;

  /// No description provided for @forcePressureAreaCalculatorAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Piston Area (A)'**
  String get forcePressureAreaCalculatorAreaLabel;

  /// No description provided for @forcePressureAreaCalculatorAreaUnit.
  ///
  /// In en, this message translates to:
  /// **'cm²'**
  String get forcePressureAreaCalculatorAreaUnit;

  /// No description provided for @forcePressureAreaCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Force (F)'**
  String get forcePressureAreaCalculatorResultLabel;

  /// No description provided for @forcePressureAreaCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'kilo'**
  String get forcePressureAreaCalculatorResultUnit;

  /// No description provided for @oilSpeedCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oil Speed from Flow & Diameter'**
  String get oilSpeedCalculatorTitle;

  /// No description provided for @oilSpeedCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates oil speed in a pipe'**
  String get oilSpeedCalculatorDescription;

  /// No description provided for @oilSpeedCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Oil Speed Calculator'**
  String get oilSpeedCalculatorPageTitle;

  /// No description provided for @oilSpeedCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'v = (q * 21.2) / d²'**
  String get oilSpeedCalculatorFormula;

  /// No description provided for @oilSpeedCalculatorFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Oil Flow (q)'**
  String get oilSpeedCalculatorFlowLabel;

  /// No description provided for @oilSpeedCalculatorFlowUnit.
  ///
  /// In en, this message translates to:
  /// **'dm³/min'**
  String get oilSpeedCalculatorFlowUnit;

  /// No description provided for @oilSpeedCalculatorDiameterLabel.
  ///
  /// In en, this message translates to:
  /// **'Pipe Diameter (d)'**
  String get oilSpeedCalculatorDiameterLabel;

  /// No description provided for @oilSpeedCalculatorDiameterUnit.
  ///
  /// In en, this message translates to:
  /// **'mm'**
  String get oilSpeedCalculatorDiameterUnit;

  /// No description provided for @oilSpeedCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'m/s'**
  String get oilSpeedCalculatorResultUnit;

  /// No description provided for @pistonSpeedCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Piston Speed from Flow & Area'**
  String get pistonSpeedCalculatorTitle;

  /// No description provided for @pistonSpeedCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates piston speed'**
  String get pistonSpeedCalculatorDescription;

  /// No description provided for @pistonSpeedCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Piston Speed Calculator'**
  String get pistonSpeedCalculatorPageTitle;

  /// No description provided for @pistonSpeedCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'v = q / (6 * A)'**
  String get pistonSpeedCalculatorFormula;

  /// No description provided for @pistonSpeedCalculatorFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow (q)'**
  String get pistonSpeedCalculatorFlowLabel;

  /// No description provided for @pistonSpeedCalculatorFlowUnit.
  ///
  /// In en, this message translates to:
  /// **'dm³/min'**
  String get pistonSpeedCalculatorFlowUnit;

  /// No description provided for @pistonSpeedCalculatorAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Piston Area (A)'**
  String get pistonSpeedCalculatorAreaLabel;

  /// No description provided for @pistonSpeedCalculatorAreaUnit.
  ///
  /// In en, this message translates to:
  /// **'cm²'**
  String get pistonSpeedCalculatorAreaUnit;

  /// No description provided for @pistonSpeedCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed (v)'**
  String get pistonSpeedCalculatorResultLabel;

  /// No description provided for @pistonSpeedCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'m/s'**
  String get pistonSpeedCalculatorResultUnit;

  /// No description provided for @volumeFlowCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow from Displacement & RPM'**
  String get volumeFlowCalculatorTitle;

  /// No description provided for @volumeFlowCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates volume flow'**
  String get volumeFlowCalculatorDescription;

  /// No description provided for @volumeFlowCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow Calculator'**
  String get volumeFlowCalculatorPageTitle;

  /// No description provided for @volumeFlowCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'q = (V * n) / 1000'**
  String get volumeFlowCalculatorFormula;

  /// No description provided for @volumeFlowCalculatorDisplacementUnit.
  ///
  /// In en, this message translates to:
  /// **'cm³/r'**
  String get volumeFlowCalculatorDisplacementUnit;

  /// No description provided for @volumeFlowCalculatorRpmUnit.
  ///
  /// In en, this message translates to:
  /// **'r/min'**
  String get volumeFlowCalculatorRpmUnit;

  /// No description provided for @volumeFlowCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'dm³/min'**
  String get volumeFlowCalculatorResultUnit;

  /// No description provided for @torqueCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Torque from Displacement & Pressure'**
  String get torqueCalculatorTitle;

  /// No description provided for @torqueCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates motor torque'**
  String get torqueCalculatorDescription;

  /// No description provided for @torqueCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Torque Calculator'**
  String get torqueCalculatorPageTitle;

  /// No description provided for @torqueCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'M = (V * Δp) / 63'**
  String get torqueCalculatorFormula;

  /// No description provided for @torqueCalculatorDisplacementLabel.
  ///
  /// In en, this message translates to:
  /// **'Displacement (V)'**
  String get torqueCalculatorDisplacementLabel;

  /// No description provided for @torqueCalculatorDisplacementUnit.
  ///
  /// In en, this message translates to:
  /// **'cm³/r'**
  String get torqueCalculatorDisplacementUnit;

  /// No description provided for @torqueCalculatorPressureDiffLabel.
  ///
  /// In en, this message translates to:
  /// **'Pressure Difference (Δp)'**
  String get torqueCalculatorPressureDiffLabel;

  /// No description provided for @torqueCalculatorPressureDiffUnit.
  ///
  /// In en, this message translates to:
  /// **'bar'**
  String get torqueCalculatorPressureDiffUnit;

  /// No description provided for @torqueCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'Nm'**
  String get torqueCalculatorResultUnit;

  /// No description provided for @hydraulicPowerCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Power from Flow & Pressure'**
  String get hydraulicPowerCalculatorTitle;

  /// No description provided for @hydraulicPowerCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates hydraulic power'**
  String get hydraulicPowerCalculatorDescription;

  /// No description provided for @hydraulicPowerCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Hydraulic Power Calculator'**
  String get hydraulicPowerCalculatorPageTitle;

  /// No description provided for @hydraulicPowerCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'P = (p * q) / 600'**
  String get hydraulicPowerCalculatorFormula;

  /// No description provided for @hydraulicPowerCalculatorPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Oil Pressure (p)'**
  String get hydraulicPowerCalculatorPressureLabel;

  /// No description provided for @hydraulicPowerCalculatorPressureUnit.
  ///
  /// In en, this message translates to:
  /// **'bar'**
  String get hydraulicPowerCalculatorPressureUnit;

  /// No description provided for @hydraulicPowerCalculatorFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow (q)'**
  String get hydraulicPowerCalculatorFlowLabel;

  /// No description provided for @hydraulicPowerCalculatorFlowUnit.
  ///
  /// In en, this message translates to:
  /// **'dm³/min'**
  String get hydraulicPowerCalculatorFlowUnit;

  /// No description provided for @hydraulicPowerCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'kW'**
  String get hydraulicPowerCalculatorResultUnit;

  /// No description provided for @powerLossCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates power loss in circuits'**
  String get powerLossCalculatorDescription;

  /// No description provided for @powerLossCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Power Loss Calculator'**
  String get powerLossCalculatorPageTitle;

  /// No description provided for @powerLossCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'P = (Δp * q) / 600'**
  String get powerLossCalculatorFormula;

  /// No description provided for @powerLossCalculatorPressureDropLabel.
  ///
  /// In en, this message translates to:
  /// **'Pressure Drop (Δp)'**
  String get powerLossCalculatorPressureDropLabel;

  /// No description provided for @powerLossCalculatorPressureDropUnit.
  ///
  /// In en, this message translates to:
  /// **'bar'**
  String get powerLossCalculatorPressureDropUnit;

  /// No description provided for @powerLossCalculatorFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume Flow (q)'**
  String get powerLossCalculatorFlowLabel;

  /// No description provided for @powerLossCalculatorFlowUnit.
  ///
  /// In en, this message translates to:
  /// **'dm³/min'**
  String get powerLossCalculatorFlowUnit;

  /// No description provided for @powerLossCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Power Loss (P)'**
  String get powerLossCalculatorResultLabel;

  /// No description provided for @powerLossCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'kW'**
  String get powerLossCalculatorResultUnit;

  /// No description provided for @efficiencyCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculates efficiency from power values'**
  String get efficiencyCalculatorDescription;

  /// No description provided for @efficiencyCalculatorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Efficiency Calculator'**
  String get efficiencyCalculatorPageTitle;

  /// No description provided for @efficiencyCalculatorFormula.
  ///
  /// In en, this message translates to:
  /// **'η = P.avg / P.tilf'**
  String get efficiencyCalculatorFormula;

  /// No description provided for @efficiencyCalculatorInputPowerUnit.
  ///
  /// In en, this message translates to:
  /// **'kW'**
  String get efficiencyCalculatorInputPowerUnit;

  /// No description provided for @efficiencyCalculatorOutputPowerUnit.
  ///
  /// In en, this message translates to:
  /// **'kW'**
  String get efficiencyCalculatorOutputPowerUnit;

  /// No description provided for @efficiencyCalculatorResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Efficiency (η)'**
  String get efficiencyCalculatorResultLabel;

  /// No description provided for @efficiencyCalculatorResultUnit.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get efficiencyCalculatorResultUnit;

  /// No description provided for @formSectionOperatorInfo.
  ///
  /// In en, this message translates to:
  /// **'Operator Information'**
  String get formSectionOperatorInfo;

  /// No description provided for @formValidationNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get formValidationNotEmpty;

  /// No description provided for @formValidationValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get formValidationValidEmail;

  /// No description provided for @formValidationPleaseSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get formValidationPleaseSelectOption;

  /// No description provided for @formSectionForkliftInfo.
  ///
  /// In en, this message translates to:
  /// **'Forklift Information'**
  String get formSectionForkliftInfo;

  /// No description provided for @formSectionCraneInfo.
  ///
  /// In en, this message translates to:
  /// **'Crane Information'**
  String get formSectionCraneInfo;

  /// No description provided for @formSectionDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get formSectionDocumentation;

  /// No description provided for @formQuestionHasCertificate.
  ///
  /// In en, this message translates to:
  /// **'Do you have a valid certificate?'**
  String get formQuestionHasCertificate;

  /// No description provided for @formQuestionHasManual.
  ///
  /// In en, this message translates to:
  /// **'Is the equipment manual available?'**
  String get formQuestionHasManual;

  /// No description provided for @formAnswerNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get formAnswerNotSelected;

  /// No description provided for @formButtonPreviewReport.
  ///
  /// In en, this message translates to:
  /// **'Preview Report'**
  String get formButtonPreviewReport;

  /// No description provided for @emailSubjectTypeControl.
  ///
  /// In en, this message translates to:
  /// **'Type Control Report - {date}'**
  String emailSubjectTypeControl(Object date);

  /// No description provided for @dateGeneratedLabel.
  ///
  /// In en, this message translates to:
  /// **'Date Generated'**
  String get dateGeneratedLabel;

  /// No description provided for @pipingCalculator.
  ///
  /// In en, this message translates to:
  /// **'Piping Calculator'**
  String get pipingCalculator;

  /// No description provided for @imagePickerPathError.
  ///
  /// In en, this message translates to:
  /// **'Error: Picked image has an empty path.'**
  String get imagePickerPathError;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @cylinderCalculatorMenu.
  ///
  /// In en, this message translates to:
  /// **'Cylinder Calculator'**
  String get cylinderCalculatorMenu;

  /// No description provided for @pumpCalculatorMenu.
  ///
  /// In en, this message translates to:
  /// **'Pump Calculator'**
  String get pumpCalculatorMenu;

  /// No description provided for @motorCalculatorMenu.
  ///
  /// In en, this message translates to:
  /// **'Motor Calculator'**
  String get motorCalculatorMenu;

  /// No description provided for @pipingCalculatorMenu.
  ///
  /// In en, this message translates to:
  /// **'Piping Calculator'**
  String get pipingCalculatorMenu;

  /// No description provided for @pressureDropCalculatorMenu.
  ///
  /// In en, this message translates to:
  /// **'Pressure Drop Calculator'**
  String get pressureDropCalculatorMenu;

  /// No description provided for @pistonRadius.
  ///
  /// In en, this message translates to:
  /// **'Piston Radius (m)'**
  String get pistonRadius;

  /// No description provided for @rodRadius.
  ///
  /// In en, this message translates to:
  /// **'Rod Radius (m)'**
  String get rodRadius;

  /// No description provided for @strokeLength.
  ///
  /// In en, this message translates to:
  /// **'Stroke Length (m)'**
  String get strokeLength;

  /// No description provided for @oilFlowRate.
  ///
  /// In en, this message translates to:
  /// **'Oil Flow Rate (m³/s)'**
  String get oilFlowRate;

  /// No description provided for @areaRatio.
  ///
  /// In en, this message translates to:
  /// **'Area Ratio'**
  String get areaRatio;

  /// No description provided for @displacement.
  ///
  /// In en, this message translates to:
  /// **'Displacement (m³/rev)'**
  String get displacement;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed (RPM)'**
  String get speed;

  /// No description provided for @volumetricEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Volumetric Efficiency (%)'**
  String get volumetricEfficiency;

  /// No description provided for @flowRate.
  ///
  /// In en, this message translates to:
  /// **'Flow Rate'**
  String get flowRate;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power (W)'**
  String get power;

  /// No description provided for @mechanicalEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Mechanical Efficiency (%)'**
  String get mechanicalEfficiency;

  /// No description provided for @displacementMode.
  ///
  /// In en, this message translates to:
  /// **'Displacement Mode'**
  String get displacementMode;

  /// No description provided for @powerMode.
  ///
  /// In en, this message translates to:
  /// **'Power Mode'**
  String get powerMode;

  /// No description provided for @pipeDiameter.
  ///
  /// In en, this message translates to:
  /// **'Pipe Diameter (m)'**
  String get pipeDiameter;

  /// No description provided for @specificGravity.
  ///
  /// In en, this message translates to:
  /// **'Specific Gravity'**
  String get specificGravity;

  /// No description provided for @absoluteViscosity.
  ///
  /// In en, this message translates to:
  /// **'Absolute Viscosity (Pa·s)'**
  String get absoluteViscosity;

  /// No description provided for @crossSectionalArea.
  ///
  /// In en, this message translates to:
  /// **'Cross-sectional Area'**
  String get crossSectionalArea;

  /// No description provided for @velocity.
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get velocity;

  /// No description provided for @reynoldsNumber.
  ///
  /// In en, this message translates to:
  /// **'Reynolds Number'**
  String get reynoldsNumber;

  /// No description provided for @orificeCoefficient.
  ///
  /// In en, this message translates to:
  /// **'Orifice Coefficient (K)'**
  String get orificeCoefficient;

  /// No description provided for @forkliftChecklistItem5.
  ///
  /// In en, this message translates to:
  /// **'Check Level of Hydraulic Oil'**
  String get forkliftChecklistItem5;

  /// No description provided for @forkliftChecklistItem6.
  ///
  /// In en, this message translates to:
  /// **'Check Level of Engine Oil'**
  String get forkliftChecklistItem6;

  /// No description provided for @forkliftChecklistItem7.
  ///
  /// In en, this message translates to:
  /// **'Check Level of Coolant'**
  String get forkliftChecklistItem7;

  /// No description provided for @forkliftChecklistItem8.
  ///
  /// In en, this message translates to:
  /// **'Check Tire Pressure and Condition'**
  String get forkliftChecklistItem8;

  /// No description provided for @forkliftChecklistItem9.
  ///
  /// In en, this message translates to:
  /// **'Inspect Forks for Damage/Wear'**
  String get forkliftChecklistItem9;

  /// No description provided for @forkliftChecklistItem10.
  ///
  /// In en, this message translates to:
  /// **'Check Mast and Lifting Chains'**
  String get forkliftChecklistItem10;

  /// No description provided for @forkliftChecklistItem11.
  ///
  /// In en, this message translates to:
  /// **'Test Brakes (Service and Parking)'**
  String get forkliftChecklistItem11;

  /// No description provided for @forkliftChecklistItem12.
  ///
  /// In en, this message translates to:
  /// **'Check Lights (Headlights, Tail lights, Warning lights)'**
  String get forkliftChecklistItem12;

  /// No description provided for @forkliftChecklistItem13.
  ///
  /// In en, this message translates to:
  /// **'Test Horn'**
  String get forkliftChecklistItem13;

  /// No description provided for @forkliftChecklistItem14.
  ///
  /// In en, this message translates to:
  /// **'Check Seatbelt Function'**
  String get forkliftChecklistItem14;

  /// No description provided for @forkliftChecklistItem15.
  ///
  /// In en, this message translates to:
  /// **'Inspect Overhead Guard'**
  String get forkliftChecklistItem15;

  /// No description provided for @forkliftChecklistItem16.
  ///
  /// In en, this message translates to:
  /// **'Check Backrest Extension'**
  String get forkliftChecklistItem16;

  /// No description provided for @forkliftChecklistItem17.
  ///
  /// In en, this message translates to:
  /// **'Verify Battery Charge/Fuel Level'**
  String get forkliftChecklistItem17;

  /// No description provided for @forkliftChecklistItem18.
  ///
  /// In en, this message translates to:
  /// **'Check for Leaks (Oil, Hydraulic Fluid)'**
  String get forkliftChecklistItem18;

  /// No description provided for @forkliftChecklistItem19.
  ///
  /// In en, this message translates to:
  /// **'Inspect Steering Mechanism'**
  String get forkliftChecklistItem19;

  /// No description provided for @forkliftChecklistItem20.
  ///
  /// In en, this message translates to:
  /// **'Check for Unusual Noises'**
  String get forkliftChecklistItem20;

  /// No description provided for @forkliftChecklistItem21.
  ///
  /// In en, this message translates to:
  /// **'Ensure Data Plate is Legible'**
  String get forkliftChecklistItem21;

  /// No description provided for @forkliftChecklistItem22.
  ///
  /// In en, this message translates to:
  /// **'Check Fire Extinguisher (if equipped)'**
  String get forkliftChecklistItem22;

  /// No description provided for @formFieldImprovementsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any improvements or remarks here...'**
  String get formFieldImprovementsHint;

  /// No description provided for @formFieldImprovementsRemarksHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any improvements or remarks here...'**
  String get formFieldImprovementsRemarksHint;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Snackbar message shown when a report has been successfully shared via native share options.
  ///
  /// In en, this message translates to:
  /// **'Report shared successfully'**
  String get formSnackbarReportShared;

  /// Text to display when a form field or answer was not provided by the user, e.g., in a PDF report.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get formAnswerNotProvided;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'no'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'no': return AppLocalizationsNo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
