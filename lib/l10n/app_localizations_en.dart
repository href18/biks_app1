// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hydraulic Calculator';

  @override
  String get firstMenu => 'Lift Calculator';

  @override
  String get secondMenu => 'My Page';

  @override
  String get courseMenu => 'Courses';

  @override
  String get liftingTable => 'Lifting Chart';

  @override
  String get threadChart => 'Thread Chart';

  @override
  String get gTable => 'G-Table';

  @override
  String get myLifts => 'My Lifts';

  @override
  String get dailyCheck => 'Daily Check';

  @override
  String get typeControl => 'Type Control';

  @override
  String get inspectionsAndChecks => 'Inspections & Checks';

  @override
  String get createdBy => 'Created by Entellix.no';

  @override
  String get howTo => 'How to calculate';

  @override
  String get howToDescription => 'The unit is tonnes. Example: 0.2 = 200kg';

  @override
  String get weightTh => 'Please enter a valid weight';

  @override
  String get del => 'parts';

  @override
  String get medWLL => 'WLL';

  @override
  String get togd => 'to Ø';

  @override
  String get mm => 'mm';

  @override
  String get tons => 'tons';

  @override
  String get typeWeight => 'Enter weight';

  @override
  String get unsymmetricLift => 'Assymetric lift';

  @override
  String get pressResult => 'Calculate';

  @override
  String folgendeU(Object arg1, Object arg2) {
    return 'Recommended for $arg1 $arg2';
  }

  @override
  String get dailyInspection => 'Daily Inspection';

  @override
  String get performedBy => 'Performed by operator before startup';

  @override
  String get truckType => 'Truck Type';

  @override
  String get truckNumber => 'Truck Number';

  @override
  String get weekNumber => 'Week No.';

  @override
  String get date => 'Date';

  @override
  String get category => 'Category';

  @override
  String get work => 'Task';

  @override
  String get preview => 'Preview';

  @override
  String get sendInspection => 'Submit';

  @override
  String get backToForm => 'Back';

  @override
  String get abnormalConditions => 'REPORT ABNORMAL CONDITIONS TO SUPERVISOR';

  @override
  String get damageDescription => 'Damage/Defects:';

  @override
  String get describeDamage => 'Describe damages';

  @override
  String get repairDescription => 'Repairs:';

  @override
  String get describeRepairs => 'Describe repairs';

  @override
  String get signature => 'Signature';

  @override
  String get noneReported => 'None';

  @override
  String get archiveNote => 'Archive for 3 years';

  @override
  String get close => 'Close';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get dailyChecksCatMotorChassis => 'Engine/Chassis';

  @override
  String get dailyChecksCatElectricTruck => 'Electric Truck';

  @override
  String get dailyChecksCatWheels => 'Wheels';

  @override
  String get dailyChecksCatSafetyEquipment => 'Safety Equipment';

  @override
  String get dailyChecksCatAdditionalEquipment => 'Attachments';

  @override
  String get dailyChecksCatOther => 'Other';

  @override
  String get dailyChecksCatCleaning => 'Cleaning';

  @override
  String get selectEquipment => 'Select equipment';

  @override
  String get dailyChecksTaskCheckDieselLevel => 'Check diesel';

  @override
  String get dailyChecksTaskCheckCoolantLevel => 'Check coolant';

  @override
  String get dailyChecksTaskCheckEngineOilLevel => 'Check engine oil';

  @override
  String get dailyChecksTaskCheckGearboxOilLevel => 'Check gearbox oil';

  @override
  String get dailyChecksTaskCheckHydraulicOilLevel => 'Check hydraulic oil';

  @override
  String get dailyChecksTaskCheckRefillWasherFluid => 'Check washer fluid';

  @override
  String get dailyChecksTaskCheckStarterBattery => 'Check battery';

  @override
  String get dailyChecksTaskCheckBatteryElectric => 'Check battery (electric)';

  @override
  String get dailyChecksTaskInspectTiresRimsBolts => 'Inspect tires/rims';

  @override
  String get dailyChecksTaskCheckLightsSoundMirrors => 'Check lights/sound';

  @override
  String get dailyChecksTaskTestBrakes => 'Test brakes';

  @override
  String get dailyChecksTaskTestSteeringHoisting => 'Test steering';

  @override
  String get dailyChecksTaskCheckLeaksDamage => 'Check for leaks';

  @override
  String get dailyChecksTaskCheckFireExtinguisherFirstAid => 'Check safety equipment';

  @override
  String get dailyChecksTaskCheckAdditionalEquipmentManual => 'Check attachments';

  @override
  String get dailyChecksTaskCheckLiftingChainForks => 'Check forks/chain';

  @override
  String get dailyChecksTaskCheckTruckCleanliness => 'Check cleanliness';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get withWeight => 'with weight';

  @override
  String get ton => 'tons';

  @override
  String get med => 'with';

  @override
  String get deleteLift => 'Delete this lift?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get weightLabel => 'Weight: ';

  @override
  String get equipmentTypeLabel => 'Equipment Type: ';

  @override
  String get dateTimeLabel => 'Date/Time: ';

  @override
  String get symmetryLabel => 'Symmetry: ';

  @override
  String get unsymmetricStatus => 'Unsymmetric';

  @override
  String get symmetricStatus => 'Symmetric';

  @override
  String get calculatedDetailsTitle => 'Calculated Details:';

  @override
  String get errorFetchingLifts => 'Error fetching saved lifts:';

  @override
  String get stackTraceLabel => 'Stack Trace';

  @override
  String get noLiftsSavedYet => 'No lifts have been saved yet.';

  @override
  String get unexpectedState => 'Unexpected state encountered.';

  @override
  String get deleteLiftConfirmationTitle => 'Delete Lift';

  @override
  String deleteLiftConfirmationContent(Object liftName) {
    return 'Are you sure you want to delete the lift \'$liftName\'?';
  }

  @override
  String get formPreviewTitle => 'Inspection Preview';

  @override
  String get formButtonPreviewInspection => 'Preview Inspection';

  @override
  String get formButtonBackToForm => 'Back to Form';

  @override
  String get formSendOptionEmail => 'Send via Email App';

  @override
  String get formSendOptionNativeMail => 'Send via Native Mail Client';

  @override
  String get formButtonSend => 'Send';

  @override
  String get emailNotConfigured => 'No email app';

  @override
  String get emailContent => 'Email content:';

  @override
  String get copiedToClipboard => 'Copied';

  @override
  String get copyToClipboard => 'Copy';

  @override
  String get error => 'Error';

  @override
  String get errorLaunching => 'Error launching';

  @override
  String get couldNotLaunchEmailApp => 'Can\'t open email';

  @override
  String get subject => 'Subject';

  @override
  String get straightLift => 'Straight Lift';

  @override
  String get snareLift => 'Choked Lift';

  @override
  String get uLift => 'U-Lift';

  @override
  String get ulv => 'U-Lift Angle';

  @override
  String get straight => 'Direct (15-45)';

  @override
  String get snare => 'Choked (15-45)';

  @override
  String get direct4560 => 'Direct (46-60)';

  @override
  String get snare4560 => 'Choked (46-60)';

  @override
  String get direct3 => 'Direct (15-45)';

  @override
  String get snare3 => 'Choked (15-45)';

  @override
  String get direct32 => 'Direct (46-60)';

  @override
  String get snare32 => 'Choked (46-60)';

  @override
  String get truckInspectionForm => 'Type control';

  @override
  String get dailyTruckInspection => 'DAILY TRUCK INSPECTION';

  @override
  String get driverName => 'Driver Name';

  @override
  String get odometerReading => 'Odometer Reading';

  @override
  String get inspectionItems => 'Inspection Items (Check if OK)';

  @override
  String get notes => 'Notes';

  @override
  String get submitInspection => 'Submit Inspection';

  @override
  String get lightsInspection => 'Lights (head, tail, brake, turn signals)';

  @override
  String get tiresInspection => 'Tires (pressure, tread, damage)';

  @override
  String get brakesInspection => 'Brakes (parking and service)';

  @override
  String get fluidsInspection => 'Fluid levels (oil, coolant, brake, power steering)';

  @override
  String get hornInspection => 'Horn';

  @override
  String get windshieldInspection => 'Windshield and wipers';

  @override
  String get mirrorsInspection => 'Mirrors';

  @override
  String get seatBeltsInspection => 'Seat belts';

  @override
  String get emergencyEquipmentInspection => 'Emergency equipment (fire extinguisher, triangles)';

  @override
  String get leaksInspection => 'No leaks (oil, fuel, coolant)';

  @override
  String get steeringInspection => 'Steering system';

  @override
  String get suspensionInspection => 'Suspension system';

  @override
  String get exhaustInspection => 'Exhaust system';

  @override
  String get couplingInspection => 'Coupling devices';

  @override
  String get cargoInspection => 'Cargo securement';

  @override
  String get fiberSling => 'Fiber sling';

  @override
  String get chain80 => 'Chain (Grade 80)';

  @override
  String get chain100 => 'Chain (Grade 100)';

  @override
  String get steelRope => 'Steel rope (FC)';

  @override
  String get steelRopeIWC => 'Steel rope (IWRC)';

  @override
  String get enterDriverName => 'Please enter driver name';

  @override
  String get enterTruckNumber => 'Please enter truck number';

  @override
  String get enterOdometer => 'Please enter odometer reading';

  @override
  String get incompleteInspection => 'Incomplete Inspection';

  @override
  String get verifyItems => 'Please verify all inspection items before submitting.';

  @override
  String get inspectionSubmitted => 'Inspection Submitted';

  @override
  String get thankYou => 'Thank you for completing the inspection.';

  @override
  String get convertFromLabel => 'Convert From';

  @override
  String get convertToLabel => 'Convert To';

  @override
  String get resultLabel => 'Result';

  @override
  String get dnSystem => 'DN (Metric)';

  @override
  String get dashSystem => 'Dash (16ths)';

  @override
  String get inchesFractionSystem => 'Inches (Fraction)';

  @override
  String get inchesDecimalSystem => 'Inches (Decimal)';

  @override
  String get mmSystem => 'Millimeters (mm)';

  @override
  String get ok => 'OK';

  @override
  String get notesHint => 'Enter any additional notes or defects found...';

  @override
  String get convertionTool => 'Hose & Pipe Converter';

  @override
  String get instructionText => 'Select a standard size to see its equivalents.';

  @override
  String get selectSizeLabel => 'Select Known Size';

  @override
  String get resultsTitle => 'Conversion Results';

  @override
  String get dnLabel => 'DN (Metric):';

  @override
  String get dashLabel => 'Dash (16ths):';

  @override
  String get inchesFractionLabel => 'Inches (Fraction):';

  @override
  String get inchesDecimalLabel => 'Inches (Decimal):';

  @override
  String get mmLabel => 'Millimeters (mm):';

  @override
  String get liftNr => 'Lift No.';

  @override
  String get riskAssessmentTruck => 'Truck Risk Assessment';

  @override
  String get formSnackbarProgressLoaded => 'Form progress loaded.';

  @override
  String get formSnackbarProgressSaved => 'Form progress saved.';

  @override
  String get formSnackbarFormCleared => 'Form cleared.';

  @override
  String get formSnackbarPleaseCompleteFields => 'Please complete all required fields.';

  @override
  String get formSnackbarReportShared => 'Report shared successfully';

  @override
  String formSnackbarEmailFailed(String error) {
    return 'Failed to send email: $error';
  }

  @override
  String get assessedBy => 'Assessed by';

  @override
  String get truckDriverName => 'Truck Driver (Name)';

  @override
  String get area => 'Area';

  @override
  String get notProvided => 'Not provided';

  @override
  String get notSelected => 'Not selected';

  @override
  String get done => 'Done';

  @override
  String get notDone => 'Not Done';

  @override
  String get actionsAndComments => 'Actions / Comments';

  @override
  String get noComments => 'No comments';

  @override
  String get previewRiskAssessment => 'Preview: Risk Assessment';

  @override
  String get generalInformation => 'General Information';

  @override
  String get assessedByName => 'Assessed by (Name)';

  @override
  String get formValidationNotEmpty => 'This field cannot be empty';

  @override
  String get areaForRiskAssessment => 'Area for risk assessment';

  @override
  String get truckInformation => 'Truck Information';

  @override
  String get selectTruckType => 'Select truck type';

  @override
  String get pleaseSelectAType => 'Please select a type';

  @override
  String get specifyOtherType => 'Specify other type/equipment';

  @override
  String get powerSource => 'Power Source';

  @override
  String get electric => 'Electric';

  @override
  String get diesel => 'Diesel';

  @override
  String get pleaseSelectPowerSource => 'Please select a power source';

  @override
  String get riskAssessment => 'Risk Assessment';

  @override
  String get driverAndDocumentation => 'Driver and Documentation';

  @override
  String get describeActionsOrComments => 'Describe necessary actions or other comments';

  @override
  String get formButtonSaveProgress => 'Save Progress';

  @override
  String get formButtonClearForm => 'Clear Form';

  @override
  String get shareRiskAssessment => 'Share Risk Assessment';

  @override
  String get unknown => 'Unknown';

  @override
  String get truckTypeT1 => 'T1 Pedestrian-operated pallet truck';

  @override
  String get truckTypeT2 => 'T2 Reach truck or stacker truck';

  @override
  String get truckTypeT3 => 'T3 High-level order picker or turret truck';

  @override
  String get truckTypeT4 => 'T4 Counterbalance truck';

  @override
  String get truckTypeT5 => 'T5 Sideloaders';

  @override
  String get truckTypeOther => 'Other types / additional equipment';

  @override
  String get checkAreaLabel => 'Check the area where the truck will operate';

  @override
  String get secureAreaLabel => 'Mark / Secure the area with cones';

  @override
  String get stableLoadLabel => 'Load stored in the area is stable and secured';

  @override
  String get trafficInOutLabel => 'Traffic in and out of the area';

  @override
  String get visualContactLabel => 'Visual contact with instructor / truck driver';

  @override
  String get winterConditionsLabel => 'Winter – Slippery, ice, snow, and slush';

  @override
  String get deicingSaltLabel => 'Is de-icing salt available for slippery driving areas';

  @override
  String get hillDrivingLabel => 'Hill driving';

  @override
  String get darknessLabel => 'Autumn / winter, darkness';

  @override
  String get infoOnDangersLabel => 'Has the course participant been informed about dangers in the area';

  @override
  String get racksCertifiedLabel => 'Are pallet racks certified and inspected';

  @override
  String get preUseCheckLabel => 'Pre-use check';

  @override
  String get truckCheckLabel => 'Truck check';

  @override
  String get typeTrainingLabel => 'Type-specific training';

  @override
  String get competenceCertLabel => 'Certificate of competence';

  @override
  String get instructorPresentLabel => 'Instructor';

  @override
  String get typeControlTitle => 'Type Control';

  @override
  String get forkliftTypeTrainingHeader => 'Forklift Type Training';

  @override
  String get regulationsSubHeader => 'In accordance with the Working Environment Act § 10-4 and the Regulations concerning Performance of Work and Use of Work Equipment § 13, 57';

  @override
  String get trainingInformationSection => 'Training Information';

  @override
  String get truckTypeLabel => 'Truck Type';

  @override
  String get truckNumberLabel => 'Truck Number';

  @override
  String get trainerNameLabel => 'Trainer Name';

  @override
  String get traineeNameLabel => 'Trainee Name';

  @override
  String get companyLabel => 'Company';

  @override
  String get trainingDateLabel => 'Training Date:';

  @override
  String get trainingChecklistSection => 'Training Checklist';

  @override
  String get additionalNotesSection => 'Additional Notes';

  @override
  String get additionalNotesHint => 'Enter any additional notes about the training...';

  @override
  String get submitTrainingButton => 'Submit Training Record';

  @override
  String get requiredFieldValidator => 'This field is required';

  @override
  String get trainingRecordedDialogTitle => 'Training Recorded';

  @override
  String get trainingRecordedDialogContent => 'The training record has been successfully saved.';

  @override
  String get commentsReasonLabel => 'Comments/Reason';

  @override
  String get optionYes => 'Yes';

  @override
  String get optionNo => 'No';

  @override
  String get optionDone => 'Done';

  @override
  String get optionNotApplicable => 'Not applicable';

  @override
  String get checklistItemLicenseAvailable => 'License available';

  @override
  String get checklistItemInstructionManualRead => 'Instruction manual read';

  @override
  String get checklistItemExplainMainParts => 'Explain main parts';

  @override
  String get checklistItemExplainLevers => 'Explain levers';

  @override
  String get checklistItemHowToStart => 'How to start';

  @override
  String get checklistItemExplainTilt => 'Explain tilt';

  @override
  String get checklistItemShowPedals => 'Show pedals';

  @override
  String get checklistItemExplainMarkings => 'Explain markings';

  @override
  String get checklistItemExplainLiftingCapacity => 'Explain lifting capacity';

  @override
  String get checklistItemExplainLiftingDiagram => 'Explain lifting diagram';

  @override
  String get checklistItemExplainDrivingHeight => 'Explain driving height';

  @override
  String get checklistItemExplainMaxLiftingCapacity => 'Explain max lifting capacity';

  @override
  String get checklistItemExplainCenterOfGravity => 'Explain center of gravity';

  @override
  String get checklistItemShowDangerousAreas => 'Show dangerous areas';

  @override
  String get checklistItemShowDailyControl => 'Show daily control';

  @override
  String get checklistItemShowTruckCharging => 'Show truck charging';

  @override
  String get checklistItemShowBatteryMaintenance => 'Show battery maintenance';

  @override
  String get checklistItemShowProperParking => 'Show proper parking';

  @override
  String get checklistItemShowCorrectGoodsHandling => 'Show correct goods handling';

  @override
  String get checklistItemShowAdditionalEquipment => 'Show additional equipment';

  @override
  String get checklistItemShowDocumentationStorage => 'Show documentation storage';

  @override
  String get dailyCheckForkliftInspectionTitle => 'Daily Check';

  @override
  String get dailyCheckCraneInspectionTitle => 'Crane Daily Check';

  @override
  String get dailyCheckForkliftLabel => 'Forklift';

  @override
  String get dailyCheckCraneLabel => 'Crane';

  @override
  String get formSectionContactInformation => '1. Contact Information';

  @override
  String get formSectionOperatorInformation => '1. Operator Information';

  @override
  String get formFieldName => 'Name';

  @override
  String get formFieldOperatorName => 'Operator Name';

  @override
  String get formFieldRequired => 'Required';

  @override
  String get formFieldEmail => 'Email';

  @override
  String get formFieldPhoneNumber => 'Phone Number';

  @override
  String get formFieldBirthdate => 'Date of Birth';

  @override
  String get formFieldForkliftModel => 'Forklift Model';

  @override
  String get formSectionCertification => '2. Certification';

  @override
  String get formSectionCertificationAndManuals => '3. Certification & Manuals';

  @override
  String get formQuestionCertificateOfCompetence => 'Do you have a certificate of competence?';

  @override
  String get formQuestionCertificateOfCompetenceCrane => 'Do you have a certificate of competence for this crane type?';

  @override
  String get formAnswerYes => 'Yes';

  @override
  String get formAnswerNo => 'No';

  @override
  String get formQuestionInstructionManualAvailable => 'Is the instruction manual available?';

  @override
  String get formSectionInspectionChecklist => 'Inspection Checklist';

  @override
  String get formSectionCraneInspectionChecklist => 'Crane Inspection Checklist';

  @override
  String get forkliftChecklistItemMainParts => 'Check the truck\'s main parts';

  @override
  String get forkliftChecklistItemLeversSwitches => 'Check levers/switches/joystick';

  @override
  String get forkliftChecklistItemStartTruck => 'Start the truck';

  @override
  String get forkliftChecklistItemPedalsHandbrake => 'Check pedals and handbrake';

  @override
  String get forkliftChecklistItemLiftingCapacity => 'Explain lifting capacity/diagram';

  @override
  String get forkliftChecklistItemCenterOfGravity => 'Explain center of gravity distance';

  @override
  String get forkliftChecklistItemMaxLiftingCapacity => 'Explain max lifting capacity/reduction';

  @override
  String get forkliftChecklistItemDrivingHeightMast => 'Check driving height/mast';

  @override
  String get forkliftChecklistItemSoundLightsMirrors => 'Check sound, lights and mirrors';

  @override
  String get forkliftChecklistItemLeaksDamageHydraulic => 'Check for leaks/damage (Hydraulic system)';

  @override
  String get forkliftChecklistItemLiftingChainForks => 'Check lifting chain and forks';

  @override
  String get forkliftChecklistItemTiresRimsBolts => 'Check tires, rims and wheel bolts';

  @override
  String get forkliftChecklistItemRiskAssessment => 'Risk assessment of dangerous areas';

  @override
  String get forkliftChecklistItemFuelBattery => 'Check fuel level/battery charging';

  @override
  String get forkliftChecklistItemBatteryMaintenance => 'Battery maintenance check';

  @override
  String get forkliftChecklistItemCorrectParking => 'Check correct parking/forks position';

  @override
  String get forkliftChecklistItemPalletHandling => 'Demonstrate correct pallet handling';

  @override
  String get forkliftChecklistItemForkSpreader => 'Check fork spreader/side offset';

  @override
  String get formSectionImprovements => 'Improvements/Remarks';

  @override
  String get formSectionImprovementsRemarks => 'Improvements/Remarks';

  @override
  String get formHintImprovementsNeeded => 'Enter any improvements needed...';

  @override
  String get formHintImprovementsRemarks => 'Enter any improvements or remarks...';

  @override
  String get formButtonSubmitInspection => 'SUBMIT INSPECTION';

  @override
  String get formButtonSubmitCraneInspection => 'SUBMIT CRANE INSPECTION';

  @override
  String get formSnackbarForkliftSubmissionSuccess => 'Forklift inspection submitted successfully';

  @override
  String get formSnackbarCraneSubmissionSuccess => 'Crane inspection submitted successfully';

  @override
  String get formSectionCraneDetails => '2. Crane Details';

  @override
  String get formFieldCraneModel => 'Crane Model';

  @override
  String get formFieldCraneID => 'Crane ID';

  @override
  String get craneChecklistItemHoistTrolley => 'Inspect Hoist/Trolley mechanisms';

  @override
  String get craneChecklistItemRopesChains => 'Check Wire Ropes/Chains for wear/damage';

  @override
  String get craneChecklistItemLimitSwitches => 'Test Upper and Lower Limit Switches';

  @override
  String get craneChecklistItemLoadChart => 'Verify Load Chart is visible and legible';

  @override
  String get craneChecklistItemHooksLatches => 'Inspect Hooks and Safety Latches';

  @override
  String get craneChecklistItemOutriggers => 'Check Outriggers/Stabilizers (if applicable)';

  @override
  String get craneChecklistItemEmergencyStop => 'Test Emergency Stop functionality';

  @override
  String get craneChecklistItemControlSystem => 'Inspect Control System (pendants, remotes)';

  @override
  String get craneChecklistItemStructuralComponents => 'Visual check of Structural Components (boom, jib)';

  @override
  String get craneChecklistItemFluidLevels => 'Check Fluid Levels (hydraulic, oil, coolant)';

  @override
  String get craneChecklistItemSlewingMechanism => 'Verify Slewing Ring/Mechanism';

  @override
  String get craneChecklistItemBrakes => 'Inspect Brakes (hoist, travel, slew)';

  @override
  String get craneChecklistItemElectricalSystems => 'Check Electrical Systems and Wiring';

  @override
  String get craneChecklistItemWarningDevices => 'Ensure Warning Devices (horn, lights) are functional';

  @override
  String get craneChecklistItemLogsReview => 'Review Maintenance and Inspection Logs';

  @override
  String get formFieldRequiredValidator => 'This field is required';

  @override
  String get formSnackbarEmailSent => 'Inspection report sent successfully!';

  @override
  String emailSubjectForkliftInspection(String date) {
    return 'Forklift Inspection Report - $date';
  }

  @override
  String emailSubjectCraneInspection(String date) {
    return 'Crane Inspection Report - $date';
  }

  @override
  String get emailBodyPreamble => 'Daily Equipment Inspection Report';

  @override
  String get emailFieldOperator => 'Operator Name';

  @override
  String get emailFieldEmail => 'Email';

  @override
  String get emailFieldPhone => 'Phone Number';

  @override
  String get emailFieldBirthdate => 'Date of Birth';

  @override
  String get emailFieldModel => 'Model';

  @override
  String get emailFieldID => 'ID';

  @override
  String get emailFieldCertificate => 'Has Certificate';

  @override
  String get emailFieldManual => 'Has Manual';

  @override
  String get emailFieldChecklist => 'Checklist';

  @override
  String get emailFieldImprovements => 'Improvements/Remarks';

  @override
  String get emailFieldDate => 'Date';

  @override
  String get emailChecklistItemStatusChecked => 'Checked';

  @override
  String get emailChecklistItemStatusUnchecked => 'Not Checked';

  @override
  String get customImageLabel => 'Selected Image';

  @override
  String get addImageOptional => 'Add Optional Image';

  @override
  String get changeImageOptional => 'Change Optional Image';

  @override
  String get previousLiftsTitle => 'Previous Lifts';

  @override
  String get noSavedLifts => 'No saved lifts yet';

  @override
  String get partsLabel => 'Parts';

  @override
  String get wllLabel => 'WLL';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get dateLabel => 'Date';

  @override
  String get errorLoadingLifts => 'Error loading lifts';

  @override
  String get saveLiftButtonLabel => 'Save Lift';

  @override
  String get selectImageSourceTitle => 'Select Image Source';

  @override
  String get cameraButtonLabel => 'Camera';

  @override
  String get galleryButtonLabel => 'Gallery';

  @override
  String get imagePickerError => 'Error picking image';

  @override
  String get cancel => 'Cancel';

  @override
  String get liftSavedSuccessfully => 'Lift saved successfully';

  @override
  String get formulaPrefix => 'Formula: ';

  @override
  String get hydraulicCalculator => 'Hydraulics';

  @override
  String get cylinderCalculator => 'Cylinder Calculator';

  @override
  String get motorCalculator => 'Motor Calculator';

  @override
  String get pumpCalculator => 'Pump Calculator';

  @override
  String get pressureDropCalculator => 'Pressure Drop Calculator';

  @override
  String get results => 'Results';

  @override
  String get pistonBoreDiameter => 'Piston/Bore Diameter';

  @override
  String get rodDiameter => 'Rod Diameter';

  @override
  String get pressure => 'Bar';

  @override
  String get oilFlow => 'Oil Flow';

  @override
  String get boreSideArea => 'Bore Side Area';

  @override
  String get boreSideForce => 'Bore Side Force';

  @override
  String get rodSideArea => 'Rod Side Area';

  @override
  String get rodSideForce => 'Rod Side Force';

  @override
  String get boreSideVelocity => 'Bore Side Velocity';

  @override
  String get rodSideVelocity => 'Rod Side Velocity';

  @override
  String get calculate => 'Calculate';

  @override
  String get volumeFlowCalculatorDisplacementLabel => 'Displacement (V)';

  @override
  String get volumeFlow => 'Volume Flow';

  @override
  String get volumeFlowCalculatorRpmLabel => 'Rotational Speed (n)';

  @override
  String get torqueCalculatorResultLabel => 'Torque (M)';

  @override
  String get hydraulicPowerCalculatorResultLabel => 'Power (P)';

  @override
  String get volumeFlowCalculatorResultLabel => 'Volume Flow (q)';

  @override
  String get oilSpeedCalculatorResultLabel => 'Speed (v)';

  @override
  String get powerLossCalculatorTitle => 'Power Loss from Flow & Pressure Drop';

  @override
  String get pressureDrop => 'Pressure Drop';

  @override
  String get powerLoss => 'Power Loss';

  @override
  String get efficiencyCalculatorTitle => 'Efficiency';

  @override
  String get efficiencyCalculatorInputPowerLabel => 'Input Power (P.tilf)';

  @override
  String get efficiencyCalculatorOutputPowerLabel => 'Output Power (P.avg)';

  @override
  String get efficiency => 'Efficiency (η)';

  @override
  String get forcePressureAreaCalculatorTitle => 'Force from Pressure & Area';

  @override
  String get forcePressureAreaCalculatorDescription => 'Calculates force on a piston stem';

  @override
  String get forcePressureAreaCalculatorPageTitle => 'Force Calculator';

  @override
  String get forcePressureAreaCalculatorFormula => 'F = p * A';

  @override
  String get forcePressureAreaCalculatorPressureLabel => 'Pressure (p)';

  @override
  String get forcePressureAreaCalculatorPressureUnit => 'bar';

  @override
  String get forcePressureAreaCalculatorAreaLabel => 'Piston Area (A)';

  @override
  String get forcePressureAreaCalculatorAreaUnit => 'cm²';

  @override
  String get forcePressureAreaCalculatorResultLabel => 'Force (F)';

  @override
  String get forcePressureAreaCalculatorResultUnit => 'kilo';

  @override
  String get oilSpeedCalculatorTitle => 'Oil Speed from Flow & Diameter';

  @override
  String get oilSpeedCalculatorDescription => 'Calculates oil speed in a pipe';

  @override
  String get oilSpeedCalculatorPageTitle => 'Oil Speed Calculator';

  @override
  String get oilSpeedCalculatorFormula => 'v = (q * 21.2) / d²';

  @override
  String get oilSpeedCalculatorFlowLabel => 'Oil Flow (q)';

  @override
  String get oilSpeedCalculatorFlowUnit => 'dm³/min';

  @override
  String get oilSpeedCalculatorDiameterLabel => 'Pipe Diameter (d)';

  @override
  String get oilSpeedCalculatorDiameterUnit => 'mm';

  @override
  String get oilSpeedCalculatorResultUnit => 'm/s';

  @override
  String get pistonSpeedCalculatorTitle => 'Piston Speed from Flow & Area';

  @override
  String get pistonSpeedCalculatorDescription => 'Calculates piston speed';

  @override
  String get pistonSpeedCalculatorPageTitle => 'Piston Speed Calculator';

  @override
  String get pistonSpeedCalculatorFormula => 'v = q / (6 * A)';

  @override
  String get pistonSpeedCalculatorFlowLabel => 'Volume Flow (q)';

  @override
  String get pistonSpeedCalculatorFlowUnit => 'dm³/min';

  @override
  String get pistonSpeedCalculatorAreaLabel => 'Piston Area (A)';

  @override
  String get pistonSpeedCalculatorAreaUnit => 'cm²';

  @override
  String get pistonSpeedCalculatorResultLabel => 'Speed (v)';

  @override
  String get pistonSpeedCalculatorResultUnit => 'm/s';

  @override
  String get volumeFlowCalculatorTitle => 'Volume Flow from Displacement & RPM';

  @override
  String get volumeFlowCalculatorDescription => 'Calculates volume flow';

  @override
  String get volumeFlowCalculatorPageTitle => 'Volume Flow Calculator';

  @override
  String get volumeFlowCalculatorFormula => 'q = (V * n) / 1000';

  @override
  String get volumeFlowCalculatorDisplacementUnit => 'cm³/r';

  @override
  String get volumeFlowCalculatorRpmUnit => 'r/min';

  @override
  String get volumeFlowCalculatorResultUnit => 'dm³/min';

  @override
  String get torqueCalculatorTitle => 'Torque from Displacement & Pressure';

  @override
  String get torqueCalculatorDescription => 'Calculates motor torque';

  @override
  String get torqueCalculatorPageTitle => 'Torque Calculator';

  @override
  String get torqueCalculatorFormula => 'M = (V * Δp) / 63';

  @override
  String get torqueCalculatorDisplacementLabel => 'Displacement (V)';

  @override
  String get torqueCalculatorDisplacementUnit => 'cm³/r';

  @override
  String get torqueCalculatorPressureDiffLabel => 'Pressure Difference (Δp)';

  @override
  String get torqueCalculatorPressureDiffUnit => 'bar';

  @override
  String get torqueCalculatorResultUnit => 'Nm';

  @override
  String get hydraulicPowerCalculatorTitle => 'Power from Flow & Pressure';

  @override
  String get hydraulicPowerCalculatorDescription => 'Calculates hydraulic power';

  @override
  String get hydraulicPowerCalculatorPageTitle => 'Hydraulic Power Calculator';

  @override
  String get hydraulicPowerCalculatorFormula => 'P = (p * q) / 600';

  @override
  String get hydraulicPowerCalculatorPressureLabel => 'Oil Pressure (p)';

  @override
  String get hydraulicPowerCalculatorPressureUnit => 'bar';

  @override
  String get hydraulicPowerCalculatorFlowLabel => 'Volume Flow (q)';

  @override
  String get hydraulicPowerCalculatorFlowUnit => 'dm³/min';

  @override
  String get hydraulicPowerCalculatorResultUnit => 'kW';

  @override
  String get powerLossCalculatorDescription => 'Calculates power loss in circuits';

  @override
  String get powerLossCalculatorPageTitle => 'Power Loss Calculator';

  @override
  String get powerLossCalculatorFormula => 'P = (Δp * q) / 600';

  @override
  String get powerLossCalculatorPressureDropLabel => 'Pressure Drop (Δp)';

  @override
  String get powerLossCalculatorPressureDropUnit => 'bar';

  @override
  String get powerLossCalculatorFlowLabel => 'Volume Flow (q)';

  @override
  String get powerLossCalculatorFlowUnit => 'dm³/min';

  @override
  String get powerLossCalculatorResultLabel => 'Power Loss (P)';

  @override
  String get powerLossCalculatorResultUnit => 'kW';

  @override
  String get efficiencyCalculatorDescription => 'Calculates efficiency from power values';

  @override
  String get efficiencyCalculatorPageTitle => 'Efficiency Calculator';

  @override
  String get efficiencyCalculatorFormula => 'η = P.avg / P.tilf';

  @override
  String get efficiencyCalculatorInputPowerUnit => 'kW';

  @override
  String get efficiencyCalculatorOutputPowerUnit => 'kW';

  @override
  String get efficiencyCalculatorResultLabel => 'Efficiency (η)';

  @override
  String get efficiencyCalculatorResultUnit => '%';

  @override
  String get formSectionOperatorInfo => 'Operator Information';

  @override
  String get formValidationValidEmail => 'Please enter a valid email address';

  @override
  String get formValidationPleaseSelectOption => 'Please select an option';

  @override
  String get formSectionForkliftInfo => 'Forklift Information';

  @override
  String get formSectionCraneInfo => 'Crane Information';

  @override
  String get formSectionDocumentation => 'Documentation';

  @override
  String get formQuestionHasCertificate => 'Do you have a valid certificate?';

  @override
  String get formQuestionHasManual => 'Is the equipment manual available?';

  @override
  String get formAnswerNotSelected => 'Not Selected';

  @override
  String get formButtonPreviewReport => 'Preview Report';

  @override
  String emailSubjectTypeControl(Object date) {
    return 'Type Control Report - $date';
  }

  @override
  String get dateGeneratedLabel => 'Date Generated';

  @override
  String get pipingCalculator => 'Piping Calculator';

  @override
  String get imagePickerPathError => 'Error: Picked image has an empty path.';

  @override
  String get reset => 'Reset';

  @override
  String get cylinderCalculatorMenu => 'Cylinder Calculator';

  @override
  String get pumpCalculatorMenu => 'Pump Calculator';

  @override
  String get motorCalculatorMenu => 'Motor Calculator';

  @override
  String get pipingCalculatorMenu => 'Piping Calculator';

  @override
  String get pressureDropCalculatorMenu => 'Pressure Drop Calculator';

  @override
  String get pistonRadius => 'Piston Radius (m)';

  @override
  String get rodRadius => 'Rod Radius (m)';

  @override
  String get strokeLength => 'Stroke Length (m)';

  @override
  String get oilFlowRate => 'Oil Flow Rate (m³/s)';

  @override
  String get areaRatio => 'Area Ratio';

  @override
  String get displacement => 'Displacement (m³/rev)';

  @override
  String get speed => 'Speed (RPM)';

  @override
  String get volumetricEfficiency => 'Volumetric Efficiency (%)';

  @override
  String get flowRate => 'Flow Rate';

  @override
  String get power => 'Power (W)';

  @override
  String get mechanicalEfficiency => 'Mechanical Efficiency (%)';

  @override
  String get displacementMode => 'Displacement Mode';

  @override
  String get powerMode => 'Power Mode';

  @override
  String get pipeDiameter => 'Pipe Diameter (m)';

  @override
  String get specificGravity => 'Specific Gravity';

  @override
  String get absoluteViscosity => 'Absolute Viscosity (Pa·s)';

  @override
  String get crossSectionalArea => 'Cross-sectional Area';

  @override
  String get velocity => 'Velocity';

  @override
  String get reynoldsNumber => 'Reynolds Number';

  @override
  String get orificeCoefficient => 'Orifice Coefficient (K)';

  @override
  String get forkliftChecklistItem5 => 'Check Level of Hydraulic Oil';

  @override
  String get forkliftChecklistItem6 => 'Check Level of Engine Oil';

  @override
  String get forkliftChecklistItem7 => 'Check Level of Coolant';

  @override
  String get forkliftChecklistItem8 => 'Check Tire Pressure and Condition';

  @override
  String get forkliftChecklistItem9 => 'Inspect Forks for Damage/Wear';

  @override
  String get forkliftChecklistItem10 => 'Check Mast and Lifting Chains';

  @override
  String get forkliftChecklistItem11 => 'Test Brakes (Service and Parking)';

  @override
  String get forkliftChecklistItem12 => 'Check Lights (Headlights, Tail lights, Warning lights)';

  @override
  String get forkliftChecklistItem13 => 'Test Horn';

  @override
  String get forkliftChecklistItem14 => 'Check Seatbelt Function';

  @override
  String get forkliftChecklistItem15 => 'Inspect Overhead Guard';

  @override
  String get forkliftChecklistItem16 => 'Check Backrest Extension';

  @override
  String get forkliftChecklistItem17 => 'Verify Battery Charge/Fuel Level';

  @override
  String get forkliftChecklistItem18 => 'Check for Leaks (Oil, Hydraulic Fluid)';

  @override
  String get forkliftChecklistItem19 => 'Inspect Steering Mechanism';

  @override
  String get forkliftChecklistItem20 => 'Check for Unusual Noises';

  @override
  String get forkliftChecklistItem21 => 'Ensure Data Plate is Legible';

  @override
  String get forkliftChecklistItem22 => 'Check Fire Extinguisher (if equipped)';

  @override
  String get formFieldImprovementsHint => 'Enter any improvements or remarks here...';

  @override
  String get formFieldImprovementsRemarksHint => 'Enter any improvements or remarks here...';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get formAnswerNotProvided => 'Not provided';
}
