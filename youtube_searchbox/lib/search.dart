
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:youtube_searchbox/searchbox.dart';




List<String> playlist = [
            'SxmhhtiaJlY',
            '7x3-0nQ5IQo',
            '7sa6YEoWsec',
            '4BK8VO3Txcc',
            'k589d-bIpGE',
            'MJ4bfSdUT2g',
            't2hZ93ZrbLM',
            '1lRfwHi9l8c',
            '04vi9iLF9sw',
            'zryJNQIGoOc',

];




class Search{
  final String title;

  const Search({
    required this.title,
  }); 
  
}




Future<String> getTitle() async{
  
    var jsonData = await getDetail(playlist[1]);
    String title = jsonData['title'];
    return "title";
  
}

Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$userUrl&format=json";

    var res = await http.get(Uri.parse(embedUrl));
    print("get youtube detail status code: " + res.statusCode.toString());

    try {
      if (res.statusCode == 200) {
        return json.decode(res.body);

      } else {
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON'+ e.toString());
      
      return null;
    }
  }

  Future<dynamic> title() async {
    var object = new YoutubeAppDemo();
    
    
  }
    
  
