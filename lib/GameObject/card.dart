import 'package:flutter/cupertino.dart';

enum CardType{
  clubs,
  diamonds,
  hearts,
  spades,
  unknown
}

class Card {
  int _rank = 0;
  CardType _type = CardType.unknown;
  bool _hide = true;
  bool _alwaysVisible = true;

  Card (this._rank,this._type,this._hide,this._alwaysVisible);

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
        Image(image: AssetImage('assets/images/card/card_back.png'),
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
          Image(image: AssetImage('assets/images/card/card_back.png'),
            width: width,
            height: height
          );
    }
    return
      Image(
        image: AssetImage('assets/images/card/${rank_text}_of_${type_text}.png'),
        width: width,
        height: height,
      );
  }
}