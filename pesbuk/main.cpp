#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QDebug>
#include <QScreen>

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Pesbuk");
    QGuiApplication::setOrganizationName("pesbuk.kugiigi");
    QGuiApplication::setApplicationName("pesbuk.kugiigi");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);

    QGuiApplication app(argc, argv);

    QSettings settings;
    QString style = QQuickStyle::name();
    if (settings.contains("style")) {
        QQuickStyle::setStyle(settings.value("style").toString());
    }
    else {
        settings.setValue("style", "Material");
        QQuickStyle::setStyle("Material");
    }

    const auto chromiumFlags = qgetenv("QTWEBENGINE_CHROMIUM_FLAGS");
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", chromiumFlags + " --enable-features=OverlayScrollbar,OverlayScrollbarFlashAfterAnyScrollUpdate,OverlayScrollbarFlashWhenMouseEnter");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());

    QScreen* screen = QGuiApplication::primaryScreen();
    engine.rootContext()->setContextProperty("physicalDotsPerInch", screen->physicalDotsPerInch());

    engine.load(QUrl(QStringLiteral("qrc:///Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
