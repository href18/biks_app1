// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appTitle => 'Hydraulisk Kalkulator';

  @override
  String get firstMenu => 'Løftekalkulator';

  @override
  String get secondMenu => 'Min Side';

  @override
  String get courseMenu => 'Kurs';

  @override
  String get liftingTable => 'Løftetabell';

  @override
  String get threadChart => 'Gjengetabell';

  @override
  String get gTable => 'G-Tabell';

  @override
  String get myLifts => 'Mine løft';

  @override
  String get dailyCheck => 'Kontroll før bruk';

  @override
  String get typeControl => 'Typekontroll';

  @override
  String get inspectionsAndChecks => 'Inspeksjon & Sjekk';

  @override
  String get createdBy => 'Laget av Entellix.no';

  @override
  String get howTo => 'Hvordan beregne';

  @override
  String get howToDescription => 'Enheten er tonn. Eksempel: 0.2 = 200kg';

  @override
  String get weightTh => 'Vennligst skriv inn en gyldig vekt';

  @override
  String get del => 'parter';

  @override
  String get medWLL => 'WLL';

  @override
  String get togd => 'til Ø';

  @override
  String get mm => 'mm';

  @override
  String get tons => 'tonn';

  @override
  String get typeWeight => 'Skriv inn vekt';

  @override
  String get unsymmetricLift => 'Usymmetrisk løft';

  @override
  String get pressResult => 'Beregn';

  @override
  String folgendeU(Object arg1, Object arg2) {
    return 'Anbefalt for $arg1 $arg2';
  }

  @override
  String get dailyInspection => 'Daglig Inspeksjon';

  @override
  String get performedBy => 'Utføres før oppstart';

  @override
  String get truckType => 'Truck Type';

  @override
  String get truckNumber => 'Trucknummer';

  @override
  String get weekNumber => 'Uke Nr.';

  @override
  String get date => 'Dato';

  @override
  String get category => 'Kategori';

  @override
  String get work => 'Oppgave';

  @override
  String get preview => 'Forhåndsvis';

  @override
  String get sendInspection => 'Send inn';

  @override
  String get backToForm => 'Tilbake';

  @override
  String get abnormalConditions => 'RAPPORTER UNORMALE FORHOLD';

  @override
  String get damageDescription => 'Skader/Defekter:';

  @override
  String get describeDamage => 'Beskriv skader';

  @override
  String get repairDescription => 'Reparasjoner:';

  @override
  String get describeRepairs => 'Beskriv reparasjoner';

  @override
  String get signature => 'Signatur';

  @override
  String get noneReported => 'Ingen';

  @override
  String get archiveNote => 'Arkiver i 3 år';

  @override
  String get close => 'Lukk';

  @override
  String get monday => 'Man';

  @override
  String get tuesday => 'Tir';

  @override
  String get wednesday => 'Ons';

  @override
  String get thursday => 'Tor';

  @override
  String get friday => 'Fre';

  @override
  String get saturday => 'Lør';

  @override
  String get sunday => 'Søn';

  @override
  String get dailyChecksCatMotorChassis => 'Motor/Chassis';

  @override
  String get dailyChecksCatElectricTruck => 'Elektrisk Truck';

  @override
  String get dailyChecksCatWheels => 'Hjul';

  @override
  String get dailyChecksCatSafetyEquipment => 'Sikkerhetsutstyr';

  @override
  String get dailyChecksCatAdditionalEquipment => 'Tilleggsutstyr';

  @override
  String get dailyChecksCatOther => 'Annet';

  @override
  String get dailyChecksCatCleaning => 'Rengjøring';

  @override
  String get selectEquipment => 'Velg utstyr';

  @override
  String get dailyChecksTaskCheckDieselLevel => 'Sjekk diesel';

  @override
  String get dailyChecksTaskCheckCoolantLevel => 'Sjekk kjølevæske';

  @override
  String get dailyChecksTaskCheckEngineOilLevel => 'Sjekk motorolje';

  @override
  String get dailyChecksTaskCheckGearboxOilLevel => 'Sjekk girkasseolje';

  @override
  String get dailyChecksTaskCheckHydraulicOilLevel => 'Sjekk hydraulikkolje';

  @override
  String get dailyChecksTaskCheckRefillWasherFluid => 'Sjekk spyllevæske';

  @override
  String get dailyChecksTaskCheckStarterBattery => 'Sjekk batteri';

  @override
  String get dailyChecksTaskCheckBatteryElectric => 'Sjekk batteri (elektrisk)';

  @override
  String get dailyChecksTaskInspectTiresRimsBolts => 'Sjekk dekk/felg';

  @override
  String get dailyChecksTaskCheckLightsSoundMirrors => 'Sjekk lys/lyd';

  @override
  String get dailyChecksTaskTestBrakes => 'Test bremser';

  @override
  String get dailyChecksTaskTestSteeringHoisting => 'Test styring';

  @override
  String get dailyChecksTaskCheckLeaksDamage => 'Sjekk for lekkasjer';

  @override
  String get dailyChecksTaskCheckFireExtinguisherFirstAid => 'Sjekk sikkerhetsutstyr';

  @override
  String get dailyChecksTaskCheckAdditionalEquipmentManual => 'Sjekk tilleggsutstyr';

  @override
  String get dailyChecksTaskCheckLiftingChainForks => 'Sjekk gafler/kjede';

  @override
  String get dailyChecksTaskCheckTruckCleanliness => 'Sjekk renhold';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get withWeight => 'med vekt';

  @override
  String get ton => 'tonn';

  @override
  String get med => 'med';

  @override
  String get deleteLift => 'Slette dette løftet?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nei';

  @override
  String get weightLabel => 'Weight: ';

  @override
  String get equipmentTypeLabel => 'Equipment Type: ';

  @override
  String get dateTimeLabel => 'Date/Time: ';

  @override
  String get symmetryLabel => 'Symmetry: ';

  @override
  String get unsymmetricStatus => 'Usymmetrisk';

  @override
  String get symmetricStatus => 'symmetrisk';

  @override
  String get calculatedDetailsTitle => 'Kalkulerte Detaljer:';

  @override
  String get errorFetchingLifts => 'Feil ved henting av løft';

  @override
  String get stackTraceLabel => 'Stack trace';

  @override
  String get noLiftsSavedYet => 'Ingen løft lagret enda. Legg til ditt første!';

  @override
  String get unexpectedState => 'En uventet tilstand oppstod.';

  @override
  String get deleteLiftConfirmationTitle => 'Slett Løft';

  @override
  String deleteLiftConfirmationContent(Object liftName) {
    return 'Are you sure you want to delete the lift \'$liftName\'?';
  }

  @override
  String get formPreviewTitle => 'Inspeksjonsforhåndsvisning';

  @override
  String get formButtonPreviewInspection => 'Forhåndsvis Inspeksjon';

  @override
  String get formButtonBackToForm => 'Tilbake til Skjema';

  @override
  String get formSendOptionEmail => 'Send via E-post App';

  @override
  String get formSendOptionNativeMail => 'Send via Standard E-postklient';

  @override
  String get formButtonSend => 'Send';

  @override
  String get emailNotConfigured => 'Ingen e-postapp';

  @override
  String get emailContent => 'E-postinnhold:';

  @override
  String get copiedToClipboard => 'Kopiert';

  @override
  String get copyToClipboard => 'Kopier';

  @override
  String get error => 'Feil';

  @override
  String get errorLaunching => 'Feil ved oppstart';

  @override
  String get couldNotLaunchEmailApp => 'Kan ikke åpne e-post';

  @override
  String get subject => 'Emne';

  @override
  String get straightLift => 'Rett løft';

  @override
  String get snareLift => 'Snaret løft';

  @override
  String get uLift => 'U-løft';

  @override
  String get ulv => 'U-løft vinkel';

  @override
  String get straight => 'Direkte (15-45)';

  @override
  String get snare => 'Snaret (15-45)';

  @override
  String get direct4560 => 'Direkte (46-60)';

  @override
  String get snare4560 => 'Snaret (46-60)';

  @override
  String get direct3 => 'Direkte (15-45)';

  @override
  String get snare3 => 'Snaret (15-45)';

  @override
  String get direct32 => 'Direkte (46-60)';

  @override
  String get snare32 => 'Snaret (46-60)';

  @override
  String get truckInspectionForm => 'Truck Inspeksjonsskjema';

  @override
  String get dailyTruckInspection => 'DAGLIG TRUCK INSPEKSJON';

  @override
  String get driverName => 'Sjåførnavn';

  @override
  String get odometerReading => 'Kilometerstand';

  @override
  String get inspectionItems => 'Inspeksjonspunkter (Kryss av hvis OK)';

  @override
  String get notes => 'Notater';

  @override
  String get submitInspection => 'Send inn inspeksjon';

  @override
  String get lightsInspection => 'Lys (front, bak, brems, blinklys)';

  @override
  String get tiresInspection => 'Dekk (trykk, mønster, skader)';

  @override
  String get brakesInspection => 'Bremser (parkering og service)';

  @override
  String get fluidsInspection => 'Væskenivå (olje, kjølevæske, bremsevæske, styring)';

  @override
  String get hornInspection => 'Horn';

  @override
  String get windshieldInspection => 'Frontrute og vindusviskere';

  @override
  String get mirrorsInspection => 'Speil';

  @override
  String get seatBeltsInspection => 'Setebelter';

  @override
  String get emergencyEquipmentInspection => 'Nødutstyr (brannslukker, varseltriangler)';

  @override
  String get leaksInspection => 'Ingen lekkasjer (olje, drivstoff, kjølevæske)';

  @override
  String get steeringInspection => 'Styringssystem';

  @override
  String get suspensionInspection => 'Opphengssystem';

  @override
  String get exhaustInspection => 'Eksosanlegg';

  @override
  String get couplingInspection => 'Koblingsanordninger';

  @override
  String get cargoInspection => 'Lastesikring';

  @override
  String get fiberSling => 'Fiberstropp';

  @override
  String get chain80 => 'Kjetting (Klasse 80)';

  @override
  String get chain100 => 'Kjetting (Klasse 100)';

  @override
  String get steelRope => 'Ståltau (FC)';

  @override
  String get steelRopeIWC => 'Ståltau (IWRC)';

  @override
  String get enterDriverName => 'Vennligst skriv inn sjåførnavn';

  @override
  String get enterTruckNumber => 'Vennligst skriv inn trucknummer';

  @override
  String get enterOdometer => 'Vennligst skriv inn kilometerstand';

  @override
  String get incompleteInspection => 'Ufullstendig inspeksjon';

  @override
  String get verifyItems => 'Vennligst kontroller alle inspeksjonspunkter før innsending.';

  @override
  String get inspectionSubmitted => 'Inspeksjon sendt inn';

  @override
  String get thankYou => 'Takk for at du fullførte inspeksjonen.';

  @override
  String get convertFromLabel => 'Konverter Fra';

  @override
  String get convertToLabel => 'Konverter Til';

  @override
  String get resultLabel => 'Resultat';

  @override
  String get dnSystem => 'DN (Metrisk)';

  @override
  String get dashSystem => 'Dash (16-deler)';

  @override
  String get inchesFractionSystem => 'Tommer (Brøk)';

  @override
  String get inchesDecimalSystem => 'Tommer (Desimal)';

  @override
  String get mmSystem => 'Millimeter (mm)';

  @override
  String get ok => 'OK';

  @override
  String get notesHint => 'Skriv inn eventuelle tilleggsnotater eller feil som er funnet...';

  @override
  String get convertionTool => 'Konverteringsverktøy';

  @override
  String get instructionText => 'Velg en standardstørrelse for å se ekvivalenter.';

  @override
  String get selectSizeLabel => 'Velg kjent størrelse';

  @override
  String get resultsTitle => 'Konverteringsresultater';

  @override
  String get dnLabel => 'DN (Metrisk):';

  @override
  String get dashLabel => 'Dash (16-deler):';

  @override
  String get inchesFractionLabel => 'Tommer (Brøk):';

  @override
  String get inchesDecimalLabel => 'Tommer (Desimal):';

  @override
  String get mmLabel => 'Millimeter (mm):';

  @override
  String get liftNr => 'Løft Nr.';

  @override
  String get riskAssessmentTruck => 'Risikovurdering Truck';

  @override
  String get formSnackbarProgressLoaded => 'Skjema-fremdrift lastet.';

  @override
  String get formSnackbarProgressSaved => 'Skjema-fremdrift lagret.';

  @override
  String get formSnackbarFormCleared => 'Skjema tømt.';

  @override
  String get formSnackbarPleaseCompleteFields => 'Vennligst fyll ut alle obligatoriske felt.';

  @override
  String get formSnackbarReportShared => 'Rapporten er klar for deling.';

  @override
  String formSnackbarEmailFailed(String error) {
    return 'Klarte ikke å sende e-post: $error';
  }

  @override
  String get assessedBy => 'Vurdert av';

  @override
  String get truckDriverName => 'Truckfører (Navn)';

  @override
  String get area => 'Område';

  @override
  String get notProvided => 'Ikke oppgitt';

  @override
  String get notSelected => 'Ikke valgt';

  @override
  String get done => 'Utført';

  @override
  String get notDone => 'Ikke utført';

  @override
  String get actionsAndComments => 'Tiltak / Kommentarer';

  @override
  String get noComments => 'Ingen kommentarer';

  @override
  String get previewRiskAssessment => 'Forhåndsvisning: Risikovurdering';

  @override
  String get generalInformation => 'Generell Informasjon';

  @override
  String get assessedByName => 'Vurdert av (Navn)';

  @override
  String get formValidationNotEmpty => 'Dette feltet kan ikke være tomt';

  @override
  String get areaForRiskAssessment => 'Område for risikovurdering';

  @override
  String get truckInformation => 'Truck Informasjon';

  @override
  String get selectTruckType => 'Velg truck type';

  @override
  String get pleaseSelectAType => 'Vennligst velg en type';

  @override
  String get specifyOtherType => 'Spesifiser annen type/utstyr';

  @override
  String get powerSource => 'Drift';

  @override
  String get electric => 'El';

  @override
  String get diesel => 'Diesel';

  @override
  String get pleaseSelectPowerSource => 'Vennligst velg driftstype';

  @override
  String get riskAssessment => 'Risikovurdering';

  @override
  String get driverAndDocumentation => 'Fører og Dokumentasjon';

  @override
  String get describeActionsOrComments => 'Beskriv nødvendige tiltak eller andre kommentarer';

  @override
  String get formButtonSaveProgress => 'Lagre Fremdrift';

  @override
  String get formButtonClearForm => 'Tøm Skjema';

  @override
  String get shareRiskAssessment => 'Del Risikovurdering';

  @override
  String get unknown => 'Ukjent';

  @override
  String get truckTypeT1 => 'T1 Lede-palletruck';

  @override
  String get truckTypeT2 => 'T2 Skyvemast eller støttebenstruck';

  @override
  String get truckTypeT3 => 'T3 Høytløftende plukk eller svinggaffeltruck';

  @override
  String get truckTypeT4 => 'T4 Motvekt-truck';

  @override
  String get truckTypeT5 => 'T5 Sidelaster';

  @override
  String get truckTypeOther => 'Andre typer / tilleggsutstyr';

  @override
  String get checkAreaLabel => 'Sjekk av område trucken skal bevege seg på';

  @override
  String get secureAreaLabel => 'Merke / Sikre område med kjegler';

  @override
  String get stableLoadLabel => 'Last som er lagret i området er stabilt og sikret';

  @override
  String get trafficInOutLabel => 'Trafikk inn og ut av området';

  @override
  String get visualContactLabel => 'Visuell kontakt med instruktør / truckfører';

  @override
  String get winterConditionsLabel => 'Vinter – Glatt, is, snø og slaps';

  @override
  String get deicingSaltLabel => 'Er det tilgjengelig strøsalt ved glatt kjøreområde';

  @override
  String get hillDrivingLabel => 'Bakkekjøring';

  @override
  String get darknessLabel => 'Høst / vinter, mørke';

  @override
  String get infoOnDangersLabel => 'Har kursdeltaker fått informasjon om farer i området';

  @override
  String get racksCertifiedLabel => 'Er pallereol sertifisert og kontrollert';

  @override
  String get preUseCheckLabel => 'Kontroll før bruk';

  @override
  String get truckCheckLabel => 'Sjekk av truck';

  @override
  String get typeTrainingLabel => 'Typeopplæring';

  @override
  String get competenceCertLabel => 'Kompetansebevis';

  @override
  String get instructorPresentLabel => 'Instruktør';

  @override
  String get typeControlTitle => 'Typekontroll';

  @override
  String get forkliftTypeTrainingHeader => 'Typeopplæring for truck';

  @override
  String get regulationsSubHeader => 'I henhold til arbeidsmiljøloven § 10-4 og forskrift om utførelse av arbeid og bruk av arbeidsutstyr § 13, 57';

  @override
  String get trainingInformationSection => 'Opplæringsinformasjon';

  @override
  String get truckTypeLabel => 'Trucktype';

  @override
  String get truckNumberLabel => 'Trucknummer';

  @override
  String get trainerNameLabel => 'Opplæringsansvarlig';

  @override
  String get traineeNameLabel => 'Deltaker';

  @override
  String get companyLabel => 'Bedrift';

  @override
  String get trainingDateLabel => 'Opplæringsdato:';

  @override
  String get trainingChecklistSection => 'Opplæringssjekkliste';

  @override
  String get additionalNotesSection => 'Tilleggsnotater';

  @override
  String get additionalNotesHint => 'Skriv inn eventuelle tilleggsnotater om opplæringen...';

  @override
  String get submitTrainingButton => 'Send inn opplæring';

  @override
  String get requiredFieldValidator => 'Dette feltet er obligatorisk';

  @override
  String get trainingRecordedDialogTitle => 'Opplæring registrert';

  @override
  String get trainingRecordedDialogContent => 'Opplæringen er blitt registrert.';

  @override
  String get commentsReasonLabel => 'Kommentarer/Årsak';

  @override
  String get optionYes => 'Ja';

  @override
  String get optionNo => 'Nei';

  @override
  String get optionDone => 'Gjennomført';

  @override
  String get optionNotApplicable => 'Ikke aktuelt';

  @override
  String get checklistItemLicenseAvailable => 'Lisens tilgjengelig';

  @override
  String get checklistItemInstructionManualRead => 'Bruksanvisning lest';

  @override
  String get checklistItemExplainMainParts => 'Forklar hoveddelene';

  @override
  String get checklistItemExplainLevers => 'Forklar spakene';

  @override
  String get checklistItemHowToStart => 'Hvordan starte';

  @override
  String get checklistItemExplainTilt => 'Forklar tipping';

  @override
  String get checklistItemShowPedals => 'Vis pedaler';

  @override
  String get checklistItemExplainMarkings => 'Forklar merking';

  @override
  String get checklistItemExplainLiftingCapacity => 'Forklar løftekapasitet';

  @override
  String get checklistItemExplainLiftingDiagram => 'Forklar løftediagram';

  @override
  String get checklistItemExplainDrivingHeight => 'Forklar kjørehøyde';

  @override
  String get checklistItemExplainMaxLiftingCapacity => 'Forklar maks løftekapasitet';

  @override
  String get checklistItemExplainCenterOfGravity => 'Forklar tyngdepunkt';

  @override
  String get checklistItemShowDangerousAreas => 'Vis farlige områder';

  @override
  String get checklistItemShowDailyControl => 'Vis daglig kontroll';

  @override
  String get checklistItemShowTruckCharging => 'Vis lading av truck';

  @override
  String get checklistItemShowBatteryMaintenance => 'Vis batteri vedlikehold';

  @override
  String get checklistItemShowProperParking => 'Vis riktig parkering';

  @override
  String get checklistItemShowCorrectGoodsHandling => 'Vis riktig godshåndtering';

  @override
  String get checklistItemShowAdditionalEquipment => 'Vis tilleggsutstyr';

  @override
  String get checklistItemShowDocumentationStorage => 'Vis dokumentasjonslagring';

  @override
  String get dailyCheckForkliftInspectionTitle => 'Daglig Sjekk Truck';

  @override
  String get dailyCheckCraneInspectionTitle => 'Daglig Sjekk Kran';

  @override
  String get dailyCheckForkliftLabel => 'Truck';

  @override
  String get dailyCheckCraneLabel => 'Kran';

  @override
  String get formSectionContactInformation => '1. Kontaktinformasjon';

  @override
  String get formSectionOperatorInformation => '1. Førerinformasjon';

  @override
  String get formFieldName => 'Navn';

  @override
  String get formFieldOperatorName => 'Operatørnavn';

  @override
  String get formFieldRequired => 'Obligatorisk';

  @override
  String get formFieldEmail => 'E-post';

  @override
  String get formFieldPhoneNumber => 'Telefonnummer';

  @override
  String get formFieldBirthdate => 'Fødselsdato';

  @override
  String get formFieldForkliftModel => 'Truckmodell';

  @override
  String get formSectionCertification => '2. Sertifisering';

  @override
  String get formSectionCertificationAndManuals => '3. Sertifisering & Manualer';

  @override
  String get formQuestionCertificateOfCompetence => 'Har du kompetansebevis?';

  @override
  String get formQuestionCertificateOfCompetenceCrane => 'Har du kompetansebevis for denne krantypen?';

  @override
  String get formAnswerYes => 'Ja';

  @override
  String get formAnswerNo => 'Nei';

  @override
  String get formQuestionInstructionManualAvailable => 'Er instruksjonsboken tilgjengelig?';

  @override
  String get formSectionInspectionChecklist => 'Inspeksjonssjekkliste';

  @override
  String get formSectionCraneInspectionChecklist => 'Kran Inspeksjonssjekkliste';

  @override
  String get forkliftChecklistItemMainParts => 'Sjekk truckens hoveddeler';

  @override
  String get forkliftChecklistItemLeversSwitches => 'Sjekk spaker/brytere/joystick';

  @override
  String get forkliftChecklistItemStartTruck => 'Start trucken';

  @override
  String get forkliftChecklistItemPedalsHandbrake => 'Sjekk pedaler og håndbrems';

  @override
  String get forkliftChecklistItemLiftingCapacity => 'Forklar løftekapasitet/diagram';

  @override
  String get forkliftChecklistItemCenterOfGravity => 'Forklar tyngdepunktsavstand';

  @override
  String get forkliftChecklistItemMaxLiftingCapacity => 'Forklar maks løftekapasitet/reduksjon';

  @override
  String get forkliftChecklistItemDrivingHeightMast => 'Sjekk kjørehøyde/mast';

  @override
  String get forkliftChecklistItemSoundLightsMirrors => 'Sjekk lyd, lys og speil';

  @override
  String get forkliftChecklistItemLeaksDamageHydraulic => 'Sjekk for lekkasjer/skade (Hydraulikksystem)';

  @override
  String get forkliftChecklistItemLiftingChainForks => 'Sjekk løftekjetting og gafler';

  @override
  String get forkliftChecklistItemTiresRimsBolts => 'Sjekk dekk, felger og hjulbolter';

  @override
  String get forkliftChecklistItemRiskAssessment => 'Risikovurdering av farlige områder';

  @override
  String get forkliftChecklistItemFuelBattery => 'Sjekk drivstoffnivå/batterilading';

  @override
  String get forkliftChecklistItemBatteryMaintenance => 'Sjekk batterivedlikehold';

  @override
  String get forkliftChecklistItemCorrectParking => 'Sjekk korrekt parkering/gaffelposisjon';

  @override
  String get forkliftChecklistItemPalletHandling => 'Demonstrer korrekt pallehåndtering';

  @override
  String get forkliftChecklistItemForkSpreader => 'Sjekk gaffelspreder/sideforskyvning';

  @override
  String get formSectionImprovements => 'Forbedringer/Merknader';

  @override
  String get formSectionImprovementsRemarks => 'Forbedringer/Merknader';

  @override
  String get formHintImprovementsNeeded => 'Skriv inn eventuelle forbedringer...';

  @override
  String get formHintImprovementsRemarks => 'Skriv inn eventuelle forbedringer eller merknader...';

  @override
  String get formButtonSubmitInspection => 'SEND INN INSPEKSJON';

  @override
  String get formButtonSubmitCraneInspection => 'SEND INN KRANINSPEKSJON';

  @override
  String get formSnackbarForkliftSubmissionSuccess => 'Truckinspeksjon sendt';

  @override
  String get formSnackbarCraneSubmissionSuccess => 'Kraninspeksjon sendt';

  @override
  String get formSectionCraneDetails => '2. Krandetaljer';

  @override
  String get formFieldCraneModel => 'Kranmodell';

  @override
  String get formFieldCraneID => 'Kran ID';

  @override
  String get craneChecklistItemHoistTrolley => 'Inspiser heise-/vognmekanismer';

  @override
  String get craneChecklistItemRopesChains => 'Sjekk ståltau/kjeder for slitasje/skade';

  @override
  String get craneChecklistItemLimitSwitches => 'Test øvre og nedre endebrytere';

  @override
  String get craneChecklistItemLoadChart => 'Verifiser at lastdiagram er synlig og lesbart';

  @override
  String get craneChecklistItemHooksLatches => 'Inspiser kroker og sikkerhetslåser';

  @override
  String get craneChecklistItemOutriggers => 'Sjekk støtteben/stabilisatorer (hvis aktuelt)';

  @override
  String get craneChecklistItemEmergencyStop => 'Test nødstoppfunksjonalitet';

  @override
  String get craneChecklistItemControlSystem => 'Inspiser kontrollsystem (pendler, fjernkontroller)';

  @override
  String get craneChecklistItemStructuralComponents => 'Visuell sjekk av strukturelle komponenter (bom, jib)';

  @override
  String get craneChecklistItemFluidLevels => 'Sjekk væskenivåer (hydraulikk, olje, kjølevæske)';

  @override
  String get craneChecklistItemSlewingMechanism => 'Verifiser svingkrans/mekanisme';

  @override
  String get craneChecklistItemBrakes => 'Inspiser bremser (heise, kjøre, sving)';

  @override
  String get craneChecklistItemElectricalSystems => 'Sjekk elektriske systemer og ledninger';

  @override
  String get craneChecklistItemWarningDevices => 'Sørg for at varslingsenheter (horn, lys) fungerer';

  @override
  String get craneChecklistItemLogsReview => 'Gjennomgå vedlikeholds- og inspeksjonslogger';

  @override
  String get formFieldRequiredValidator => 'Dette feltet er påkrevd';

  @override
  String get formSnackbarEmailSent => 'Inspeksjonsrapport sendt!';

  @override
  String emailSubjectForkliftInspection(String date) {
    return 'Truck Inspeksjonsrapport - $date';
  }

  @override
  String emailSubjectCraneInspection(String date) {
    return 'Kran Inspeksjonsrapport - $date';
  }

  @override
  String get emailBodyPreamble => 'Rapport Daglig Utstyrsinspeksjon';

  @override
  String get emailFieldOperator => 'Operatørnavn';

  @override
  String get emailFieldEmail => 'E-post';

  @override
  String get emailFieldPhone => 'Telefonnummer';

  @override
  String get emailFieldBirthdate => 'Fødselsdato';

  @override
  String get emailFieldModel => 'Modell';

  @override
  String get emailFieldID => 'ID';

  @override
  String get emailFieldCertificate => 'Har Sertifikat';

  @override
  String get emailFieldManual => 'Har Manual';

  @override
  String get emailFieldChecklist => 'Sjekkliste';

  @override
  String get emailFieldImprovements => 'Forbedringer/Merknader';

  @override
  String get emailFieldDate => 'Dato';

  @override
  String get emailChecklistItemStatusChecked => 'Sjekket';

  @override
  String get emailChecklistItemStatusUnchecked => 'Ikke Sjekket';

  @override
  String get customImageLabel => 'Valgt bilde';

  @override
  String get addImageOptional => 'Legg til valgfritt bilde';

  @override
  String get changeImageOptional => 'Endre valgfritt bilde';

  @override
  String get previousLiftsTitle => 'Tidligere løft';

  @override
  String get noSavedLifts => 'Ingen lagrede løft enda';

  @override
  String get partsLabel => 'Parter';

  @override
  String get wllLabel => 'WLL';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get dateLabel => 'Dato';

  @override
  String get errorLoadingLifts => 'Feil ved lasting av løft';

  @override
  String get saveLiftButtonLabel => 'Lagre løft';

  @override
  String get selectImageSourceTitle => 'Velg bildekilde';

  @override
  String get cameraButtonLabel => 'Kamera';

  @override
  String get galleryButtonLabel => 'Galleri';

  @override
  String get imagePickerError => 'Feil ved valg av bilde';

  @override
  String get cancel => 'Avbryt';

  @override
  String get liftSavedSuccessfully => 'Løft lagret';

  @override
  String get formulaPrefix => 'Formel: ';

  @override
  String get hydraulicCalculator => 'Hydraulikk';

  @override
  String get cylinderCalculator => 'Sylinderkalkulator';

  @override
  String get motorCalculator => 'Motorkalkulator';

  @override
  String get pumpCalculator => 'Pumpekalkulator';

  @override
  String get pressureDropCalculator => 'Trykkfallkalkulator';

  @override
  String get results => 'Resultater';

  @override
  String get pistonBoreDiameter => 'Stempel-/sylinderdiameter';

  @override
  String get rodDiameter => 'Stangdiameter';

  @override
  String get pressure => 'Bar';

  @override
  String get oilFlow => 'Oljestrøm';

  @override
  String get boreSideArea => 'Stempelsideareal';

  @override
  String get boreSideForce => 'Kraft stempelside';

  @override
  String get rodSideArea => 'Stangsideareal';

  @override
  String get rodSideForce => 'Kraft stangside';

  @override
  String get boreSideVelocity => 'Hastighet stempelside';

  @override
  String get rodSideVelocity => 'Hastighet stangside';

  @override
  String get calculate => 'Beregn';

  @override
  String get volumeFlowCalculatorDisplacementLabel => 'Fortregningsvolum';

  @override
  String get volumeFlow => 'Volumstrøm';

  @override
  String get volumeFlowCalculatorRpmLabel => 'Turtall';

  @override
  String get torqueCalculatorResultLabel => 'Dreiemoment (M)';

  @override
  String get hydraulicPowerCalculatorResultLabel => 'Effekt (P)';

  @override
  String get volumeFlowCalculatorResultLabel => 'Volumstrøm (q)';

  @override
  String get oilSpeedCalculatorResultLabel => 'Hastighet (v)';

  @override
  String get powerLossCalculatorTitle => 'Effekttap i kretser';

  @override
  String get pressureDrop => 'Trykkfall';

  @override
  String get powerLoss => 'Effekttap';

  @override
  String get efficiencyCalculatorTitle => 'Virkningsgrad';

  @override
  String get efficiencyCalculatorInputPowerLabel => 'Tilført Effekt (P.tilf)';

  @override
  String get efficiencyCalculatorOutputPowerLabel => 'Avgitt Effekt (P.avg)';

  @override
  String get efficiency => 'Virkningsgrad (η)';

  @override
  String get forcePressureAreaCalculatorTitle => 'Kraft fra Trykk & Areal';

  @override
  String get forcePressureAreaCalculatorDescription => 'Beregner kraft på en stempelstang';

  @override
  String get forcePressureAreaCalculatorPageTitle => 'Kraftkalkulator';

  @override
  String get forcePressureAreaCalculatorFormula => 'F = p * A';

  @override
  String get forcePressureAreaCalculatorPressureLabel => 'Trykk (p)';

  @override
  String get forcePressureAreaCalculatorPressureUnit => 'bar';

  @override
  String get forcePressureAreaCalculatorAreaLabel => 'Stempelareal (A)';

  @override
  String get forcePressureAreaCalculatorAreaUnit => 'cm²';

  @override
  String get forcePressureAreaCalculatorResultLabel => 'Kraft (F)';

  @override
  String get forcePressureAreaCalculatorResultUnit => 'kilo';

  @override
  String get oilSpeedCalculatorTitle => 'Oljehastighet fra Flow & Diameter';

  @override
  String get oilSpeedCalculatorDescription => 'Beregner oljehastighet i et rør';

  @override
  String get oilSpeedCalculatorPageTitle => 'Oljehastighetskalkulator';

  @override
  String get oilSpeedCalculatorFormula => 'v = (q * 21.2) / d²';

  @override
  String get oilSpeedCalculatorFlowLabel => 'Oljestrøm (q)';

  @override
  String get oilSpeedCalculatorFlowUnit => 'dm³/min';

  @override
  String get oilSpeedCalculatorDiameterLabel => 'Rørdiameter (d)';

  @override
  String get oilSpeedCalculatorDiameterUnit => 'mm';

  @override
  String get oilSpeedCalculatorResultUnit => 'm/s';

  @override
  String get pistonSpeedCalculatorTitle => 'Stempelhastighet fra Flow & Areal';

  @override
  String get pistonSpeedCalculatorDescription => 'Beregner stempelhastighet';

  @override
  String get pistonSpeedCalculatorPageTitle => 'Stempelhastighetskalkulator';

  @override
  String get pistonSpeedCalculatorFormula => 'v = q / (6 * A)';

  @override
  String get pistonSpeedCalculatorFlowLabel => 'Volumstrøm (q)';

  @override
  String get pistonSpeedCalculatorFlowUnit => 'dm³/min';

  @override
  String get pistonSpeedCalculatorAreaLabel => 'Stempelareal (A)';

  @override
  String get pistonSpeedCalculatorAreaUnit => 'cm²';

  @override
  String get pistonSpeedCalculatorResultLabel => 'Hastighet (v)';

  @override
  String get pistonSpeedCalculatorResultUnit => 'm/s';

  @override
  String get volumeFlowCalculatorTitle => 'Volumstrøm fra Slagvolum & Turtall';

  @override
  String get volumeFlowCalculatorDescription => 'Beregner volumstrøm';

  @override
  String get volumeFlowCalculatorPageTitle => 'Volumstrømkalkulator';

  @override
  String get volumeFlowCalculatorFormula => 'q = (V * n) / 1000';

  @override
  String get volumeFlowCalculatorDisplacementUnit => 'cm³/r';

  @override
  String get volumeFlowCalculatorRpmUnit => 'r/min';

  @override
  String get volumeFlowCalculatorResultUnit => 'dm³/min';

  @override
  String get torqueCalculatorTitle => 'Dreiemoment fra Slagvolum & Trykk';

  @override
  String get torqueCalculatorDescription => 'Beregner motormoment';

  @override
  String get torqueCalculatorPageTitle => 'Dreiemomentkalkulator';

  @override
  String get torqueCalculatorFormula => 'M = (V * Δp) / 63';

  @override
  String get torqueCalculatorDisplacementLabel => 'Slagvolum (V)';

  @override
  String get torqueCalculatorDisplacementUnit => 'cm³/r';

  @override
  String get torqueCalculatorPressureDiffLabel => 'Trykkforskjell (Δp)';

  @override
  String get torqueCalculatorPressureDiffUnit => 'bar';

  @override
  String get torqueCalculatorResultUnit => 'Nm';

  @override
  String get hydraulicPowerCalculatorTitle => 'Effekt fra Flow & Trykk';

  @override
  String get hydraulicPowerCalculatorDescription => 'Beregner hydraulisk effekt';

  @override
  String get hydraulicPowerCalculatorPageTitle => 'Hydraulisk Effektkalkulator';

  @override
  String get hydraulicPowerCalculatorFormula => 'P = (p * q) / 600';

  @override
  String get hydraulicPowerCalculatorPressureLabel => 'Oljetrykk (p)';

  @override
  String get hydraulicPowerCalculatorPressureUnit => 'bar';

  @override
  String get hydraulicPowerCalculatorFlowLabel => 'Volumstrøm (q)';

  @override
  String get hydraulicPowerCalculatorFlowUnit => 'dm³/min';

  @override
  String get hydraulicPowerCalculatorResultUnit => 'kW';

  @override
  String get powerLossCalculatorDescription => 'Beregner effekttap i kretser';

  @override
  String get powerLossCalculatorPageTitle => 'Effekttapkalkulator';

  @override
  String get powerLossCalculatorFormula => 'P = (Δp * q) / 600';

  @override
  String get powerLossCalculatorPressureDropLabel => 'Trykkfall (Δp)';

  @override
  String get powerLossCalculatorPressureDropUnit => 'bar';

  @override
  String get powerLossCalculatorFlowLabel => 'Volumstrøm (q)';

  @override
  String get powerLossCalculatorFlowUnit => 'dm³/min';

  @override
  String get powerLossCalculatorResultLabel => 'Effekttap (P)';

  @override
  String get powerLossCalculatorResultUnit => 'kW';

  @override
  String get efficiencyCalculatorDescription => 'Beregner virkningsgrad fra effektverdier';

  @override
  String get efficiencyCalculatorPageTitle => 'Virkningsgradkalkulator';

  @override
  String get efficiencyCalculatorFormula => 'η = P.avg / P.tilf';

  @override
  String get efficiencyCalculatorInputPowerUnit => 'kW';

  @override
  String get efficiencyCalculatorOutputPowerUnit => 'kW';

  @override
  String get efficiencyCalculatorResultLabel => 'Virkningsgrad (η)';

  @override
  String get efficiencyCalculatorResultUnit => '%';

  @override
  String get formSectionOperatorInfo => 'Operatørinformasjon';

  @override
  String get formValidationValidEmail => 'Vennligst skriv inn en gyldig e-postadresse';

  @override
  String get formValidationPleaseSelectOption => 'Vennligst velg et alternativ';

  @override
  String get formSectionForkliftInfo => 'Truckinformasjon';

  @override
  String get formSectionCraneInfo => 'Kraninformasjon';

  @override
  String get formSectionDocumentation => 'Dokumentasjon';

  @override
  String get formQuestionHasCertificate => 'Har du gyldig sertifikat?';

  @override
  String get formQuestionHasManual => 'Er utstyrsmanualen tilgjengelig?';

  @override
  String get formAnswerNotSelected => 'Ikke valgt';

  @override
  String get formButtonPreviewReport => 'Forhåndsvis rapport';

  @override
  String emailSubjectTypeControl(Object date) {
    return 'Typekontrollrapport - $date';
  }

  @override
  String get dateGeneratedLabel => 'Dato generert';

  @override
  String get pipingCalculator => 'Rørkalkulator';

  @override
  String get imagePickerPathError => 'Feil: Bildestien er tom etter valg av bilde.';

  @override
  String get reset => 'Nullstill';

  @override
  String get cylinderCalculatorMenu => 'Sylinderkalkulator';

  @override
  String get pumpCalculatorMenu => 'Pumpekalkulator';

  @override
  String get motorCalculatorMenu => 'Motorkalkulator';

  @override
  String get pipingCalculatorMenu => 'Rørkalkulator';

  @override
  String get pressureDropCalculatorMenu => 'Trykkfallkalkulator';

  @override
  String get pistonRadius => 'Stempelradius (m)';

  @override
  String get rodRadius => 'Stangradius (m)';

  @override
  String get strokeLength => 'Slaglengde (m)';

  @override
  String get oilFlowRate => 'Oljestrømningsrate (m³/s)';

  @override
  String get areaRatio => 'Arealforhold';

  @override
  String get displacement => 'Sylinder volum (m³/omdr)';

  @override
  String get speed => 'Hastighet (RPM)';

  @override
  String get volumetricEfficiency => 'Volumetrisk effektivitet (%)';

  @override
  String get flowRate => 'Strømningshastighet';

  @override
  String get power => 'Effekt (W)';

  @override
  String get mechanicalEfficiency => 'Mekanisk effektivitet (%)';

  @override
  String get displacementMode => 'Volummodus';

  @override
  String get powerMode => 'Effektmodus';

  @override
  String get pipeDiameter => 'Rørdiameter (m)';

  @override
  String get specificGravity => 'Spesifikk vekt';

  @override
  String get absoluteViscosity => 'Absolutt viskositet (Pa·s)';

  @override
  String get crossSectionalArea => 'Tverrsnittsareal';

  @override
  String get velocity => 'Hastighet';

  @override
  String get reynoldsNumber => 'Reynolds tall';

  @override
  String get orificeCoefficient => 'Blenderkoeffisient (K)';

  @override
  String get forkliftChecklistItem5 => 'Sjekk nivå på hydraulikkolje';

  @override
  String get forkliftChecklistItem6 => 'Sjekk nivå på motorolje';

  @override
  String get forkliftChecklistItem7 => 'Sjekk nivå på kjølevæske';

  @override
  String get forkliftChecklistItem8 => 'Sjekk dekktrykk og tilstand';

  @override
  String get forkliftChecklistItem9 => 'Inspiser gafler for skade/slitasje';

  @override
  String get forkliftChecklistItem10 => 'Sjekk mast og løftekjeder';

  @override
  String get forkliftChecklistItem11 => 'Test bremser (drifts- og parkeringsbrems)';

  @override
  String get forkliftChecklistItem12 => 'Sjekk lys (frontlys, baklys, varsellys)';

  @override
  String get forkliftChecklistItem13 => 'Test horn';

  @override
  String get forkliftChecklistItem14 => 'Sjekk funksjon på sikkerhetsbelte';

  @override
  String get forkliftChecklistItem15 => 'Inspiser takvern';

  @override
  String get forkliftChecklistItem16 => 'Sjekk ryggstøtteforlenger';

  @override
  String get forkliftChecklistItem17 => 'Verifiser batterilading/drivstoffnivå';

  @override
  String get forkliftChecklistItem18 => 'Sjekk for lekkasjer (olje, hydraulikkvæske)';

  @override
  String get forkliftChecklistItem19 => 'Inspiser styremekanisme';

  @override
  String get forkliftChecklistItem20 => 'Sjekk for uvanlige lyder';

  @override
  String get forkliftChecklistItem21 => 'Sørg for at typeskilt er lesbart';

  @override
  String get forkliftChecklistItem22 => 'Sjekk brannslukningsapparat (hvis utstyrt)';

  @override
  String get formFieldImprovementsHint => 'Skriv inn forbedringer eller merknader her...';

  @override
  String get formFieldImprovementsRemarksHint => 'Skriv inn forbedringer eller merknader her...';

  @override
  String get helloWorld => 'Hallo Verden!';

  @override
  String get formAnswerNotProvided => 'Ikke oppgitt';
}
