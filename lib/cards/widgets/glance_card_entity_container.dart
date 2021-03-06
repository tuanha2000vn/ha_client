part of '../../main.dart';

class GlanceCardEntityContainer extends StatelessWidget {

  final bool showName;
  final bool showState;
  final bool nameInTheBottom;
  final double iconSize;
  final double nameFontSize;
  final bool wordsWrapInName;

  GlanceCardEntityContainer({
    Key key,
    @required this.showName,
    @required this.showState,
    this.nameInTheBottom: false,
    this.iconSize: Sizes.iconSize,
    this.nameFontSize: Sizes.smallFontSize,
    this.wordsWrapInName: false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EntityWrapper entityWrapper = EntityModel.of(context).entityWrapper;
    if (entityWrapper.entity.statelessType == StatelessEntityType.MISSED) {
      return MissedEntityWidget();
    }
    if (entityWrapper.entity.statelessType > StatelessEntityType.MISSED) {
      return Container(width: 0.0, height: 0.0,);
    }
    List<Widget> result = [];
    if (!nameInTheBottom) {
      if (showName) {
        result.add(_buildName());
      }
    } else {
      if (showState) {
        result.add(_buildState());
      }
    }
    result.add(
        EntityIcon(
          padding: EdgeInsets.all(0.0),
          size: iconSize,
        )
    );
    if (!nameInTheBottom) {
      if (showState) {
        result.add(_buildState());
      }
    } else {
      result.add(_buildName());
    }

    return Center(
      child: InkResponse(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: result,
        ),
        onTap: () => entityWrapper.handleTap(),
        onLongPress: () => entityWrapper.handleHold(),
      ),
    );
  }

  Widget _buildName() {
    return EntityName(
      padding: EdgeInsets.only(bottom: Sizes.rowPadding),
      textOverflow: TextOverflow.ellipsis,
      wordsWrap: wordsWrapInName,
      textAlign: TextAlign.center,
      fontSize: nameFontSize,
    );
  }

  Widget _buildState() {
    return SimpleEntityState(
      textAlign: TextAlign.center,
      expanded: false,
      maxLines: 1,
      padding: EdgeInsets.only(top: Sizes.rowPadding),
    );
  }
}