import 'package:flutter/material.dart';
import 'package:youtube_searchbox/search.dart';
import 'package:youtube_searchbox/searchbox.dart' as eos;
import 'package:youtube_searchbox/search.dart';
import 'package:youtube_searchbox/searchbox.dart';
import 'package:youtube_searchbox/youtubePlayerLast.dart';


void main() {
  runApp(SearchClass());
}

var allSearch = [

];

var temporaryTitlr = [

];

var videoUniqueId = "Nothing";

class SearchClass extends StatefulWidget {
  const SearchClass({super.key});

  @override
  State<SearchClass> createState() => _SearchClassState();
}

class _SearchClassState extends State<SearchClass> {

  bool isValid = false;


@override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(eos.titleList != null){
      isValid = true;
    }

    for(int i = 0; i < eos.playlist.length; i++){
      
      allSearch.add(Search(title: eos.titleList[i]));
    }

    
  }

  final controller = TextEditingController();
  List<dynamic> searches = allSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [

          SafeArea(
            child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                    onChanged: searchFor,
                    ),
                    
                    
          ),

                  Expanded(
                    child: ListView.builder
                  (
                    itemCount: searches.length,
                    itemBuilder: ( (context, index) {
                    final search = searches[index];

                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(search.title, style: TextStyle(color: Colors.black),),
                          onTap: () {
                            
                            
                            
                            String temp = search.title;
                            
                            
                            
                            for(int i = 0; i < eos.playlist.length; i++){
                              
                              if (temporaryTitlr[i].toString() == temp){
                                videoUniqueId = eos.playlist[i];
                              }
                            }
                            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  YoutubeAppLast(accuratePlay: eos.playlist[index],)),
            );
                            

                          },
                        ),
                      ),
                    );
                  })))

        ],
      ),
      
    );
  }

void searchFor(String query){
  final suggestions = allSearch.where((search) {
    final searchTitle = search.title.toLowerCase();
    final input = query.toLowerCase();

    return searchTitle.contains(input);
    
  }).toList();

  setState(() => searches = suggestions);

}

}