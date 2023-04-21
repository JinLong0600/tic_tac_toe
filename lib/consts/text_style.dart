import 'package:flutter/material.dart';

const bold = "bold";
const regular = "regular";
const debrosee = "debrosee";

font35({family = "debrosee"}) {
  return TextStyle(
    fontSize: 35.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: family,
  );
}

fontGrey800_35({family = "debrosee"}) {
  return TextStyle(
    fontSize: 35.0,
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontFamily: family,
  );
}

font20({family = "debrosee"}) {
  return TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontFamily: family,
  );
}

fontGrey600_20({family = "debrosee"}) {
  return TextStyle(
    fontSize: 20.0,
    color: Colors.grey.shade600,
    fontWeight: FontWeight.bold,
    fontFamily: family,
  );
}