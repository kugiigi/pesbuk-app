TEMPLATE = app
TARGET = pesbuk

load(ubuntu-click)

CONFIG += c++11


QT += qml quick gui quickcontrols2

SOURCES += main.cpp

RESOURCES += pesbuk.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  pesbuk.apparmor \
               icon.svg \
               splash.svg \
               content-hub.json \
               app-dispatcher.json

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               pesbuk.desktop

#specify where the config files are installed to
config_files.path = /pesbuk
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /pesbuk
desktop_file.files = $$OUT_PWD/pesbuk.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

DISTFILES += \
    ui/Dashboard.qml \
    components/Dashboard/FlowItems.qml \
    components/AddBottomEdge.qml \
    ui/AddFullPage.qml \
    ui/QuickAddPage.qml \
    components/Common/ColumnFlow.qml \
    components/Common/LIstViewPopover.qml \
    components/BottomEdge/InitialRectangle.qml \
    components/Common/ActionButtonDelegate.qml \
    components/Dashboard/FlowItem.qml \
    components/Dashboard/FlowItemHeader.qml \
    components/Dashboard/FlowItemListItem.qml \
    library/accounting.js \
    ui/MainPage.qml \
    ui/DetailView.qml \
    ui/StatisticsView.qml \
    components/DetailView/GroupItem.qml \
    components/DetailView/SingleItem.qml \
    library/ApplicationFunctions.js \
    components/DetailView/SingleItemChild.qml \
    components/MainPageHeader.qml \
    components/Dashboard/ViewHeader.qml \
    components/DetailView/PageHeaderExtensionBar.qml \
    components/Common/SnappingFlickable.qml \
    themes/default/parent_theme \
    themes/default/Palette.qml \
    components/Common/PopupDialog.qml \
    components/DetailView/DetailsDialog.qml \
    components/DetailView/DetailsDialogItem.qml \
    components/Dashboard/FlowItemExpandItem.qml \
    components/AddFullPage/DescriptionField.qml \
    components/AddFullPage/DateField.qml \
    components/AddFullPage/CategoryField.qml \
    components/AddFullPage/ValueField.qml \
    components/AddFullPage/CommentsField.qml \
    components/Dashboard/DashboardItem.qml \
    components/ExpenseListModel.qml \
    components/ListModels/ExpenseAutoCompleteListModel.qml \
    components/DetailView/StatsBar.qml \
    components/DetailView/StatsBarCloseButton.qml \
    components/DetailView/ViewAllItem.qml \
    components/StatisticsView/ChartComponent.qml \
    components/ListModels/ChartModel.qml \
    components/QChart/ChartLegend.qml \
    components/QChart/ChartLegendItem.qml \
    components/QChart/Chart.qml \
    components/StatisticsView/ChartHeader.qml \
    components/AddCategory/NameField.qml \
    components/AddCategory/DescriptionField.qml \
    components/AddCategory/ColorField.qml \
    ui/ManageReports.qml \
    ui/AddReport.qml \
    components/AddReport/NameField.qml \
    components/AddReport/TypeField.qml \
    components/AddReport/DateRangeField.qml \
    ui/AddDebtPage.qml \
    components/QuickAddPage/BottomBarNavigation.qml \
    components/QuickAddPage/BottomBarItem.qml \
    components/ListModels/QuickAddModel.qml \
    components/QuickAddPage/QuickAddItem.qml \
    components/QuickAddPage/AddQuickExpenseDialog.qml \
    components/AddReport/DescriptionField.qml \
    components/AddReport/DateModeField.qml \
    components/AddReport/DateFromField.qml \
    components/AddReport/DateToField.qml \
    components/AddReport/FilterException.qml \
    components/AddReport/CategoryField.qml
