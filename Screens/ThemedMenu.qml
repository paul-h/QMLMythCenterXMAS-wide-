import QtQuick 2.0
import Base 1.0

BaseScreen
{
    property alias model: listView.model

    defaultFocusItem: listView

    Component.onCompleted:
    {
        showTitle(true, model.title);
        showTime(true);
        showTicker(true);
        showVideo(true);

        title.source = settings.themePath + model.logo
    }

    Loader
    {
        id: menuLoader
    }

    Image
    {
        id: title
        x: xscale(24); y: yscale(28)
        width: xscale(sourceSize.width)
        height: yscale(sourceSize.height)
        source: settings.themePath + "title/title_tv.png"
    }

    Image
    {
        id: logo
        x: xscale(30); y: yscale(594)
        width: xscale(sourceSize.width)
        height: yscale(sourceSize.height)
        source: settings.themePath + "ui/mythtv_logo.png"
    }

    Rectangle
    {
        x: xscale(200); y: yscale(150)
        width: xscale(500); height: yscale(360)
        color: "#00000000"
        Component
        {
            id: menuDelegate
            Item
            {
                width: parent.width; height: yscale(60)
                TitleText
                {
                    text: menutext
                    fontFamily: theme.menuFontFamily
                    fontPixelSize: xscale(theme.menuFontPixelSize)
                    fontBold: theme.menuFontBold
                    fontColor: theme.menuFontColor
                    shadowAlpha: theme.menuShadowAlpha
                    shadowColor: theme.menuShadowColor
                    shadowXOffset: theme.menuShadowXOffset
                    shadowYOffset: theme.menuShadowYOffset
                    x: xscale(10); width: parent.width - xscale(20);
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index
                    }
                }
            }
        }

        ListView
        {
            id: listView
            width: parent.width; height: parent.height
            delegate: menuDelegate
            highlight: Image {source: settings.themePath + "ui/button_on.png"}
            focus: true
            clip: true
            keyNavigationWraps: true

            Keys.onPressed:
            {
                if (event.key === Qt.Key_PageDown)
                {
                    currentIndex = currentIndex + 6 >= model.count ? model.count - 1 : currentIndex + 6;
                    event.accepted = true;
                    downSound.play();
                }
                else if (event.key === Qt.Key_PageUp)
                {
                    currentIndex = currentIndex - 6 < 0 ? 0 : currentIndex - 6;
                    event.accepted = true;
                    upSound.play()
                }
                else if (event.key === Qt.Key_Up)
                {
                    event.accepted = false;
                    upSound.play()
                }
                else if (event.key === Qt.Key_Down)
                {
                    event.accepted = false;
                    downSound.play()
                }
            }

            Keys.onReturnPressed:
            {
                event.accepted = true;
                returnSound.play();

                if (model.get(currentIndex).loaderSource === "ThemedMenu.qml")
                {
                    menuLoader.source = settings.menuPath + model.get(currentIndex).menuSource;
                    stack.push({item: Qt.resolvedUrl("ThemedMenu.qml"), properties:{model: menuLoader.item}});
                }
                else
                {
                    stack.push({item: Qt.resolvedUrl(model.get(currentIndex).loaderSource)})
                }

                event.accepted = true;
            }
        }
    }
}
