#include "pushhelper.h"
#include <QApplication>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QStringList>


PushHelper::PushHelper(const QString appId, const QString infile, const QString outfile, QObject *parent) : QObject(parent),
mInfile(infile), mOutfile(outfile)
{
    connect(&mPushClient, SIGNAL(persistentCleared()),
    this, SLOT(notificationDismissed()));

    mPushClient.setAppId(appId);
    mPushClient.registerApp(appId);
}

void PushHelper::process() {
    QJsonObject pushMessage = readPushMessage(mInfile);
    mPostalMessage = pushToPostalMessage(pushMessage);

    // persistentCleared not called!
    notificationDismissed();
}

void PushHelper::notificationDismissed() {
    writePostalMessage(mPostalMessage, mOutfile);
    Q_EMIT done(); // Why does this not work?
}

QJsonObject PushHelper::readPushMessage(const QString &filename) {
    QFile file(filename);
    file.open(QIODevice::ReadOnly | QIODevice::Text);

    QString val = file.readAll();
    file.close();
    return QJsonDocument::fromJson(val.toUtf8()).object();
}

void PushHelper::writePostalMessage(const QJsonObject &postalMessage, const QString &filename) {
    QFile out;
    out.setFileName(filename);
    out.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate);

    QTextStream(&out) << QJsonDocument(postalMessage).toJson();
    out.close();
}

void PushHelper::dismissNotification(const QString &tag) {
    QStringList tags;
    tags << tag;
    mPushClient.clearPersistent(tags);
}

QJsonObject PushHelper::pushToPostalMessage(const QJsonObject &pushMessage) {
    
    QJsonObject notification;
    notification = pushMessage["notification"].toObject();

    QString tag = notification["tag"].toString();
    
    dismissNotification(tag);

    return QJsonObject{
        {"notification", notification}
    };
}
