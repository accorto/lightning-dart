// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

final _keepAnalysisHappy = Intl.defaultLocale;

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'fr';

  static m0(type) => "${type} Fichier";

  static m1(count) => "${count} records";

  static m2(selectedCount, totalCount) => "${selectedCount} de ${totalCount} records";

  static m3(columnName, columnNumber) => "${columnName} déjà dans la colonne ${columnNumber}";

  static m4(columnName) => "${columnName} est obligatoire et non mappé";

  static m5(mapCount) => "${mapCount} colonnes mappées";

  static m6(missingCount) => "${missingCount} colonnes obligatoires manquantes";

  static m7(rowCount) => "${rowCount} sélectionné pour l&#39;importation";

  static m8(count) => "${Intl.plural(count, zero: 'no records', one: '${count} record', other: '${count} records')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => {
    "appsAction" : MessageLookupByLibrary.simpleMessage("action"),
    "appsActionDelete" : MessageLookupByLibrary.simpleMessage("Effacer"),
    "appsActionDeleteSelected" : MessageLookupByLibrary.simpleMessage("Supprimer sélectionnée"),
    "appsActionDown" : MessageLookupByLibrary.simpleMessage("Vers le bas"),
    "appsActionEdit" : MessageLookupByLibrary.simpleMessage("modifier"),
    "appsActionExclude" : MessageLookupByLibrary.simpleMessage("Exclure"),
    "appsActionExport" : MessageLookupByLibrary.simpleMessage("Exportation"),
    "appsActionImport" : MessageLookupByLibrary.simpleMessage("Importer"),
    "appsActionInfo" : MessageLookupByLibrary.simpleMessage("Info"),
    "appsActionLayout" : MessageLookupByLibrary.simpleMessage("Disposition"),
    "appsActionNew" : MessageLookupByLibrary.simpleMessage("Nouveau"),
    "appsActionNo" : MessageLookupByLibrary.simpleMessage("Non"),
    "appsActionQuery" : MessageLookupByLibrary.simpleMessage("Question"),
    "appsActionRefresh" : MessageLookupByLibrary.simpleMessage("Rafraîchir"),
    "appsActionReset" : MessageLookupByLibrary.simpleMessage("Réinitialiser"),
    "appsActionSave" : MessageLookupByLibrary.simpleMessage("sauvegarder"),
    "appsActionSubmit" : MessageLookupByLibrary.simpleMessage("Soumettre"),
    "appsActionUp" : MessageLookupByLibrary.simpleMessage("en haut"),
    "appsActionYes" : MessageLookupByLibrary.simpleMessage("Oui"),
    "appsActions" : MessageLookupByLibrary.simpleMessage("actes"),
    "appsLogoutLabel" : MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "appsMainHidePrevent" : MessageLookupByLibrary.simpleMessage("Ne peut pas masquer"),
    "appsMainShowPrevent" : MessageLookupByLibrary.simpleMessage("Vous ne pouvez pas afficher"),
    "appsMenuHelp" : MessageLookupByLibrary.simpleMessage("Aidez-moi"),
    "appsNewWindow" : MessageLookupByLibrary.simpleMessage("Nouvelle fenetre"),
    "appsSettingsCacheLabel" : MessageLookupByLibrary.simpleMessage("cachette"),
    "appsSettingsEnvironmentGeo" : MessageLookupByLibrary.simpleMessage("Mise à jour Geo Infos"),
    "appsSettingsEnvironmentLabel" : MessageLookupByLibrary.simpleMessage("Environnement"),
    "appsSettingsLabel" : MessageLookupByLibrary.simpleMessage("Paramètres"),
    "appsSettingsMessagesClear" : MessageLookupByLibrary.simpleMessage("Effacer Messages"),
    "appsSettingsMessagesLabel" : MessageLookupByLibrary.simpleMessage("messages"),
    "appsSettingsMessagesNone" : MessageLookupByLibrary.simpleMessage("Pas de messages"),
    "appsSettingsTabLabel" : MessageLookupByLibrary.simpleMessage("Paramètres"),
    "appsSettingsTabSaved" : MessageLookupByLibrary.simpleMessage("Paramètres sauvegardés"),
    "cardPanelGroupBy" : MessageLookupByLibrary.simpleMessage("Par groupe"),
    "cardPanelGroupByTitle" : MessageLookupByLibrary.simpleMessage("sélectionner une colonne pour regrouper les enregistrements"),
    "cardPanelOthers" : MessageLookupByLibrary.simpleMessage("D&#39;autres valeurs"),
    "cardPanelShowEmpty" : MessageLookupByLibrary.simpleMessage("Afficher vide"),
    "cardPanelShowEmptyTitle" : MessageLookupByLibrary.simpleMessage("Afficher les colonnes vides"),
    "editorValidateRequired" : MessageLookupByLibrary.simpleMessage("S&#39;il vous plaît fournir une valeur"),
    "editorValidateTooLong" : MessageLookupByLibrary.simpleMessage("Valeur trop long"),
    "filterOpBetween" : MessageLookupByLibrary.simpleMessage("entre"),
    "filterOpDateDay" : MessageLookupByLibrary.simpleMessage("journée"),
    "filterOpDateLast" : MessageLookupByLibrary.simpleMessage("dernier"),
    "filterOpDateMonth" : MessageLookupByLibrary.simpleMessage("mois"),
    "filterOpDateNext" : MessageLookupByLibrary.simpleMessage("prochain"),
    "filterOpDateQuarter" : MessageLookupByLibrary.simpleMessage("trimestre"),
    "filterOpDateThis" : MessageLookupByLibrary.simpleMessage("ce"),
    "filterOpDateWeek" : MessageLookupByLibrary.simpleMessage("semaine"),
    "filterOpDateYear" : MessageLookupByLibrary.simpleMessage("an"),
    "filterOpEquals" : MessageLookupByLibrary.simpleMessage("équivaut à"),
    "filterOpGreater" : MessageLookupByLibrary.simpleMessage("plus grand"),
    "filterOpGreaterEquals" : MessageLookupByLibrary.simpleMessage("plus ou égaux"),
    "filterOpIn" : MessageLookupByLibrary.simpleMessage("dans"),
    "filterOpLess" : MessageLookupByLibrary.simpleMessage("Moins"),
    "filterOpLessEquals" : MessageLookupByLibrary.simpleMessage("moins ou égaux"),
    "filterOpLike" : MessageLookupByLibrary.simpleMessage("comme"),
    "filterOpNotEquals" : MessageLookupByLibrary.simpleMessage("pas égaux"),
    "filterOpNotIn" : MessageLookupByLibrary.simpleMessage("pas dedans"),
    "filterOpNotLike" : MessageLookupByLibrary.simpleMessage("pas comme"),
    "filterOpNotNull" : MessageLookupByLibrary.simpleMessage("pas null"),
    "filterOpNull" : MessageLookupByLibrary.simpleMessage("nul"),
    "fkDialogFind" : MessageLookupByLibrary.simpleMessage("Trouvez dans les dossiers -ou- Recherche avec le nom (entrée)"),
    "fkDialogTitle" : MessageLookupByLibrary.simpleMessage("Chercher"),
    "graphElementSyncTable" : MessageLookupByLibrary.simpleMessage("Synchronisation avec le tableau"),
    "graphElementTitle" : MessageLookupByLibrary.simpleMessage("Graphique"),
    "lButtonGroupMore" : MessageLookupByLibrary.simpleMessage("Plus"),
    "lDatePickerDropdownNext" : MessageLookupByLibrary.simpleMessage("Aller au mois suivant"),
    "lDatePickerDropdownPrev" : MessageLookupByLibrary.simpleMessage("Aller au mois précédent"),
    "lDatePickerDropdownToday" : MessageLookupByLibrary.simpleMessage("aujourd&#39;hui"),
    "lFormElementClear" : MessageLookupByLibrary.simpleMessage("Clear Value"),
    "lFormElementNotRequired" : MessageLookupByLibrary.simpleMessage("optionnel"),
    "lFormElementRequired" : MessageLookupByLibrary.simpleMessage("Obligatoire"),
    "lFormError" : MessageLookupByLibrary.simpleMessage("Formulaire erreur"),
    "lFormReset" : MessageLookupByLibrary.simpleMessage("Réinitialiser"),
    "lFormSave" : MessageLookupByLibrary.simpleMessage("sauvegarder"),
    "lFormSubmit" : MessageLookupByLibrary.simpleMessage("Soumettre"),
    "lInputDateInvalidInputDate" : MessageLookupByLibrary.simpleMessage("Entrée non valide pour la date"),
    "lInputDateInvalidInputDateTime" : MessageLookupByLibrary.simpleMessage("Entrée non valide pour le temps de la date"),
    "lInputDateInvalidInputTime" : MessageLookupByLibrary.simpleMessage("Entrée non valide pour le temps"),
    "lInputDateInvalidValue" : MessageLookupByLibrary.simpleMessage("valeur invalide"),
    "lInputDurationHint" : MessageLookupByLibrary.simpleMessage("heures avec décimale ou deux points (1,5 = 01h30) -ou- avec indicateur (5d1h20m ou 1h 5d 10) minutes -ou- (&gt; = 15)"),
    "lInputDurationHourHint" : MessageLookupByLibrary.simpleMessage("navigateur: heures avec décimale ou deux points (1,5 = 1:30) ou minutes (&gt; = 15)"),
    "lInputDurationInvalidInput" : MessageLookupByLibrary.simpleMessage("Entrée non valide pour une durée"),
    "lInputDurationInvalidValue" : MessageLookupByLibrary.simpleMessage("valeur invalide"),
    "lInputDurationNumberHint" : MessageLookupByLibrary.simpleMessage("mobiles: heures avec décimales (1,5) ou minutes (&gt; = 15)"),
    "lLookupInvalidInput" : MessageLookupByLibrary.simpleMessage("Option non valide"),
    "lLookupInvalidValue" : MessageLookupByLibrary.simpleMessage("valeur invalide"),
    "lLookupLabel" : MessageLookupByLibrary.simpleMessage("Chercher"),
    "lLookupNoMatch" : MessageLookupByLibrary.simpleMessage("Aucune option correspondante trouvée"),
    "lLookupTimezoneDefault" : MessageLookupByLibrary.simpleMessage("Par défaut Timezone"),
    "lLookupTimezoneTimeTitle" : MessageLookupByLibrary.simpleMessage("Temps Timezone sélectionné"),
    "lModalCancel" : MessageLookupByLibrary.simpleMessage("Annuler"),
    "lModalClose" : MessageLookupByLibrary.simpleMessage("Fermer"),
    "lModalExecute" : MessageLookupByLibrary.simpleMessage("Exécuter"),
    "lModalSave" : MessageLookupByLibrary.simpleMessage("sauvegarder"),
    "lNotificationAlert" : MessageLookupByLibrary.simpleMessage("Alert (Info)"),
    "lNotificationClose" : MessageLookupByLibrary.simpleMessage("Fermer"),
    "lNotificationError" : MessageLookupByLibrary.simpleMessage("Erreur"),
    "lNotificationSuccess" : MessageLookupByLibrary.simpleMessage("le succès"),
    "lNotificationWarning" : MessageLookupByLibrary.simpleMessage("Attention"),
    "lObjectHomeFilter" : MessageLookupByLibrary.simpleMessage("Filtre"),
    "lObjectHomeFilterAll" : MessageLookupByLibrary.simpleMessage("Tous les dossiers"),
    "lObjectHomeFilterItemColumnName" : MessageLookupByLibrary.simpleMessage("Nom de colonne"),
    "lObjectHomeFilterItemDelete" : MessageLookupByLibrary.simpleMessage("Effacer"),
    "lObjectHomeFilterItemOperation" : MessageLookupByLibrary.simpleMessage("Opération"),
    "lObjectHomeFilterRecent" : MessageLookupByLibrary.simpleMessage("Vu récemment"),
    "lObjectHomeFind" : MessageLookupByLibrary.simpleMessage("Retrouvez dans View"),
    "lObjectHomeLayoutCards" : MessageLookupByLibrary.simpleMessage("Cartes"),
    "lObjectHomeLayoutCompact" : MessageLookupByLibrary.simpleMessage("Liste Compact"),
    "lObjectHomeLayoutDisplay" : MessageLookupByLibrary.simpleMessage("Afficher comme"),
    "lObjectHomeLayoutTable" : MessageLookupByLibrary.simpleMessage("Table"),
    "lObjectHomeLookupFindInList" : MessageLookupByLibrary.simpleMessage("Retrouvez dans la liste des filtres"),
    "lObjectHomeLookupList" : MessageLookupByLibrary.simpleMessage("Liste de filtres"),
    "lObjectHomeLookupMore" : MessageLookupByLibrary.simpleMessage("Plus"),
    "lObjectHomeSave" : MessageLookupByLibrary.simpleMessage("sauvegarder"),
    "lObjectHomeShowFilter" : MessageLookupByLibrary.simpleMessage("Show Filter"),
    "lObjectHomeShowGraph" : MessageLookupByLibrary.simpleMessage("Afficher le graphique"),
    "lObjectHomeSort" : MessageLookupByLibrary.simpleMessage("Trier par"),
    "lPicklistMultiAdd" : MessageLookupByLibrary.simpleMessage("Ajouter"),
    "lPicklistMultiAvailable" : MessageLookupByLibrary.simpleMessage("Disponible"),
    "lPicklistMultiDown" : MessageLookupByLibrary.simpleMessage("Vers le bas"),
    "lPicklistMultiRemove" : MessageLookupByLibrary.simpleMessage("Retirer"),
    "lPicklistMultiSelected" : MessageLookupByLibrary.simpleMessage("Choisi"),
    "lPicklistMultiUp" : MessageLookupByLibrary.simpleMessage("en haut"),
    "lPicklistSelectOption" : MessageLookupByLibrary.simpleMessage("Choisir une option"),
    "lPillRemove" : MessageLookupByLibrary.simpleMessage("Retirer"),
    "lRecordCtrlDetails" : MessageLookupByLibrary.simpleMessage("Détails"),
    "lRecordCtrlRelated" : MessageLookupByLibrary.simpleMessage("en relation"),
    "lSpinnerWorking" : MessageLookupByLibrary.simpleMessage("travailler"),
    "lTableColumnSortAsc" : MessageLookupByLibrary.simpleMessage("Trier par ordre croissant"),
    "lTableColumnSortDec" : MessageLookupByLibrary.simpleMessage("Trier decending"),
    "lTablePagerNext" : MessageLookupByLibrary.simpleMessage("Prochain"),
    "lTablePagerPrevious" : MessageLookupByLibrary.simpleMessage("précédent"),
    "lTablePagerSize" : MessageLookupByLibrary.simpleMessage("Taille de la page"),
    "lTableRowSelectAll" : MessageLookupByLibrary.simpleMessage("Sélectionner tout"),
    "lTableRowSelectRow" : MessageLookupByLibrary.simpleMessage("Sélectionnez Row"),
    "lTableStatisticGraphSelect" : MessageLookupByLibrary.simpleMessage("Sélection graphique"),
    "lTableStatisticMatchSelect" : MessageLookupByLibrary.simpleMessage("Sélection match"),
    "lTableStatisticTotal" : MessageLookupByLibrary.simpleMessage("Total"),
    "lTableSumRowSummary" : MessageLookupByLibrary.simpleMessage("Résumé"),
    "newWindowOpen" : MessageLookupByLibrary.simpleMessage("ouvrir dans une nouvelle fenetre"),
    "newWindowOpened" : MessageLookupByLibrary.simpleMessage("ouvert dans une nouvelle fenêtre"),
    "objectCtrl1Record" : MessageLookupByLibrary.simpleMessage("Un enregistrement"),
    "objectCtrlBackList" : MessageLookupByLibrary.simpleMessage("Retour à la liste"),
    "objectCtrlFilterDelete" : MessageLookupByLibrary.simpleMessage("Supprimer le filtre?"),
    "objectCtrlFilterDeleteText" : MessageLookupByLibrary.simpleMessage("Voulez-vous supprimer le filtre en cours?"),
    "objectCtrlFilterNew" : MessageLookupByLibrary.simpleMessage("Créer un nouveau filtre?"),
    "objectCtrlFilterNewText" : MessageLookupByLibrary.simpleMessage("Le déposant actuel ne peut pas être changé. Avez-vous WNAT pour créer un nouveau filtre?"),
    "objectCtrlFiltered" : MessageLookupByLibrary.simpleMessage("Filtré"),
    "objectCtrlMatching" : MessageLookupByLibrary.simpleMessage("correspondant à"),
    "objectCtrlNoRecordInfo" : MessageLookupByLibrary.simpleMessage("Aucun enregistrement à afficher - changer Trier ou créer de nouveaux"),
    "objectCtrlNoRecords" : MessageLookupByLibrary.simpleMessage("Pas d&#39;enregistrements"),
    "objectCtrlProcessing" : MessageLookupByLibrary.simpleMessage("En traitement"),
    "objectCtrlQuerying" : MessageLookupByLibrary.simpleMessage("Interrogation"),
    "objectCtrlRecords" : MessageLookupByLibrary.simpleMessage("Enregistrements"),
    "objectCtrlSortedBy" : MessageLookupByLibrary.simpleMessage("Trié par"),
    "objectEditEdit" : MessageLookupByLibrary.simpleMessage("modifier"),
    "objectEditError" : MessageLookupByLibrary.simpleMessage("Erreur de communication"),
    "objectEditNew" : MessageLookupByLibrary.simpleMessage("Nouveau"),
    "objectExportColumns" : MessageLookupByLibrary.simpleMessage("Colonnes"),
    "objectExportDownload" : MessageLookupByLibrary.simpleMessage("Télécharger"),
    "objectExportFile" : m0,
    "objectExportFormat" : MessageLookupByLibrary.simpleMessage("Sélectionnez Format"),
    "objectExportPreview" : MessageLookupByLibrary.simpleMessage("Aperçu"),
    "objectExportRecords" : m1,
    "objectExportRecordsSelected" : m2,
    "objectExportSelectColumns" : MessageLookupByLibrary.simpleMessage("Sélectionner les colonnes"),
    "objectExportTitle" : MessageLookupByLibrary.simpleMessage("Exportation"),
    "objectHomeFilterPanel" : MessageLookupByLibrary.simpleMessage("Filtre"),
    "objectHomeFilterPanelAddFilter" : MessageLookupByLibrary.simpleMessage("Ajouter un filtre"),
    "objectHomeFilterPanelExecute" : MessageLookupByLibrary.simpleMessage("Exécuter"),
    "objectHomeFilterPanelSave" : MessageLookupByLibrary.simpleMessage("Enregistrer + Exécuter"),
    "objectHomeFilterPanelSaveName" : MessageLookupByLibrary.simpleMessage("Nom du filtre"),
    "objectHomeFilterPanelSyncTable" : MessageLookupByLibrary.simpleMessage("Synchronisation avec le tableau"),
    "objectImportAddColumn" : MessageLookupByLibrary.simpleMessage("Ajouter une colonne"),
    "objectImportButton" : MessageLookupByLibrary.simpleMessage("Importer"),
    "objectImportCheckValues" : MessageLookupByLibrary.simpleMessage("Vérifiez les valeurs"),
    "objectImportColumnAlreadyMapped" : m3,
    "objectImportColumnNotMapped" : m4,
    "objectImportColumnsMapped" : m5,
    "objectImportDateFormatHelp" : MessageLookupByLibrary.simpleMessage("Java date de style et le type motif (SimpleDateFormat) - si elle est définie d&#39;abord utilisé pour les champs de date"),
    "objectImportDateFormatLabel" : MessageLookupByLibrary.simpleMessage("Personnalisé Date / Heure Format"),
    "objectImportDuplicate" : MessageLookupByLibrary.simpleMessage("Dupliquer"),
    "objectImportFileLabel" : MessageLookupByLibrary.simpleMessage("Sélectionnez un fichier à importer"),
    "objectImportLineCheck" : MessageLookupByLibrary.simpleMessage("Vérifier"),
    "objectImportLineEmpty" : MessageLookupByLibrary.simpleMessage("vide"),
    "objectImportLineLine" : MessageLookupByLibrary.simpleMessage("Ligne"),
    "objectImportLineValueNotFound" : MessageLookupByLibrary.simpleMessage("Value not found ou invalide"),
    "objectImportMandatoryMissing" : m6,
    "objectImportMap" : MessageLookupByLibrary.simpleMessage("Carte à la colonne"),
    "objectImportMapColumns" : MessageLookupByLibrary.simpleMessage("Carte colonnes!"),
    "objectImportRowsSelected" : m7,
    "objectImportSelectCsv" : MessageLookupByLibrary.simpleMessage("Sélectionnez le fichier cvs"),
    "objectImportTitle" : MessageLookupByLibrary.simpleMessage("Importer"),
    "optionUtilNo" : MessageLookupByLibrary.simpleMessage("Non"),
    "optionUtilYes" : MessageLookupByLibrary.simpleMessage("Oui"),
    "preferenceGlobalSave" : MessageLookupByLibrary.simpleMessage("Enregistrer les préférences que Global"),
    "preferenceNothingToSave" : MessageLookupByLibrary.simpleMessage("Rien à sauver"),
    "preferenceSaved" : MessageLookupByLibrary.simpleMessage("Préférences enregistrées en tant que Global Preferences"),
    "recordInfoLabel" : MessageLookupByLibrary.simpleMessage("Info"),
    "serviceComErrorButton" : MessageLookupByLibrary.simpleMessage("Rafraîchir la page"),
    "serviceComErrorMsg" : MessageLookupByLibrary.simpleMessage("Désolé à ce sujet - s&#39;il vous plaît réessayer plus tard."),
    "serviceComErrorTitle" : MessageLookupByLibrary.simpleMessage("Erreur de communication"),
    "statByNone" : MessageLookupByLibrary.simpleMessage("Aucun"),
    "statByPeriodDay" : MessageLookupByLibrary.simpleMessage("journée"),
    "statByPeriodMonth" : MessageLookupByLibrary.simpleMessage("Mois"),
    "statByPeriodQuarter" : MessageLookupByLibrary.simpleMessage("Trimestre"),
    "statByPeriodWeek" : MessageLookupByLibrary.simpleMessage("Semaine"),
    "statByPeriodYear" : MessageLookupByLibrary.simpleMessage("An"),
    "statCalcBy" : MessageLookupByLibrary.simpleMessage("Groupe"),
    "statCalcByNone" : MessageLookupByLibrary.simpleMessage("Aucun"),
    "statCalcByTitle" : MessageLookupByLibrary.simpleMessage("Sélectionnez une colonne"),
    "statCalcColumnDate" : MessageLookupByLibrary.simpleMessage("date"),
    "statCalcDate" : MessageLookupByLibrary.simpleMessage("par"),
    "statCalcDateNone" : MessageLookupByLibrary.simpleMessage("Total"),
    "statCalcNoData" : MessageLookupByLibrary.simpleMessage("Pas de données"),
    "statCalcPeriod" : MessageLookupByLibrary.simpleMessage("par"),
    "statCalcPeriodTitle" : MessageLookupByLibrary.simpleMessage("date de groupe par période"),
    "statCalcWhat" : MessageLookupByLibrary.simpleMessage("Afficher"),
    "statCalcWhatCount" : MessageLookupByLibrary.simpleMessage("Compter"),
    "tableCtrlDelete1Record" : MessageLookupByLibrary.simpleMessage("Supprimer enregistrement en cours"),
    "tableCtrlDelete1RecordText" : MessageLookupByLibrary.simpleMessage("Voulez-vous supprimer l&#39;enregistrement en cours?"),
    "tableCtrlDeleteRecords" : MessageLookupByLibrary.simpleMessage("Effacer la sélection Records?"),
    "tableCtrlDeleteRecordsText" : MessageLookupByLibrary.simpleMessage("Voulez-vous supprimer les enregistrements sélectionnés?"),
    "tableCtrlNewRecord" : MessageLookupByLibrary.simpleMessage("Nouveau"),
    "tableCtrlRecords" : m8,
    "tableLayout" : MessageLookupByLibrary.simpleMessage("Tableau Disposition"),
    "tableLayoutColumns" : MessageLookupByLibrary.simpleMessage("Colonnes"),
    "tableStatisticsGroupBy" : MessageLookupByLibrary.simpleMessage("Par groupe"),
    "tableSumCellAvg" : MessageLookupByLibrary.simpleMessage("Moyenne"),
    "tableSumCellCount" : MessageLookupByLibrary.simpleMessage("Les enregistrements avec des valeurs"),
    "tableSumCellMax" : MessageLookupByLibrary.simpleMessage("Max"),
    "tableSumCellMin" : MessageLookupByLibrary.simpleMessage("Min"),
    "tableSumCellNull" : MessageLookupByLibrary.simpleMessage("aucune valeur"),
    "tableSumCellSum" : MessageLookupByLibrary.simpleMessage("Somme"),
    "tableSumCellTotal" : MessageLookupByLibrary.simpleMessage("Nombre de dossiers")
  };
}
