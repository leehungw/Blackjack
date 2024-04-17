import 'package:flutter/cupertino.dart';

enum CardType{
  clubs,
  diamonds,
  hearts,
  spades,
  unknown
}

class GameCard {
  int _rank = 0;
  CardType _type = CardType.unknown;
  bool _hide = true;
  bool _alwaysVisible = true;

  GameCard (this._rank,this._type,this._hide,this._alwaysVisible);

  int get rank{
    return _rank;
  }

  CardType get type{
    return _type;
  }

  bool get hide{
    return _hide;
  }

  int getValue(){
    return _rank <= 10 ? _rank : 10;
  }

  void flip(){
    _hide = !_hide;
  }

  Image getImage(double width, double height){
    if (_hide && !_alwaysVisible){
      return
        Image(image: AssetImage("assets/images/cards/card_back.png"),
          width: width,
          height: height
        );
    }
    String rank_text = "";
    switch (_rank){
      case 1:
        rank_text = "ace";
        break;
      case 11:
        rank_text = "jack";
        break;
      case 12:
        rank_text = "queen";
        break;
      case 13:
        rank_text = "king";
        break;
      default:
        rank_text = _rank.toString();
    }
    String type_text = "";
    switch (_type){
      case CardType.spades:
        type_text = "spades";
        break;
      case CardType.hearts:
        type_text = "hearts";
        break;
      case CardType.diamonds:
        type_text = "diamonds";
        break;
      case CardType.clubs:
        type_text = "clubs";
        break;
      case CardType.unknown:
        return
          Image(image: AssetImage("assets/images/cards/card_back.png"),
            width: width,
            height: height
          );
    }
    return
      Image(
        image: AssetImage("assets/images/cards/${rank_text}_of_${type_text}.png"),
        width: width,
        height: height,
      );
  }

  // Online Method

  @override
  String toString(){
    String type;
    switch(_type) {
      case CardType.clubs:
        type = "clubs";
        break;
      case CardType.diamonds:
        type = "diamonds";
        break;
      case CardType.hearts:
        type = "hearts";
        break;
      case CardType.spades:
        type = "spades";
        break;
      case CardType.unknown:
        return "";
    }

    return "${type}_$_rank";
  }

  static GameCard? parse(String cardString, bool hide, bool alwaysVisible){
    CardType type;
    int rank;

    List<String> cardData = cardString.split("_");
    if (cardData.length != 2){
      return null;
    }

    switch(cardData[0]) {
      case "clubs":
        type = CardType.clubs;
        break;
      case "diamonds":
        type = CardType.diamonds;
        break;
      case "hearts":
        type = CardType.hearts;
        break;
      case "spades":
        type = CardType.spades;
        break;
      default:
        return null;
    }

    try {
      rank = int.parse(cardData[1]);
    }
    catch (e){
      return null;
    }

    return GameCard(rank, type, hide, alwaysVisible);
  }
}