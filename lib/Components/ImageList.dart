import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';

class ImageList extends StatefulWidget {
  const ImageList({
    Key key,
    @required this.height,
    @required this.chef,
    this.edit
  }) : super(key: key);

  final double height;
  final Chef chef;
  final bool edit;

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  Future<List<dynamic>> getImages;

  @override
  void initState() {
    getImages = ImageFunctions().getChefsImages(widget.chef.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getImages,
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done) {
            return Container(
                height: widget.height * .2,
                child: Center(child: PlatformCircularProgressIndicator()));
          } else {
            List<dynamic> images = snapshot.data;
            if(widget.edit){
              if (images.length == 0) {
                images.add('create');
              } else if (images[images.length - 1] != 'create') {
                images.add('create');
              }
            }
            return Container(
              height: widget.height * .2,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    if (images[index] == 'create') {
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              ImageSourceModal()
                                  .showModal(context, 'chef', widget.chef.id);
                            },
                            child: Container(
                              width: widget.height * .2,
                              color: Colors.grey[350],
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(PlatformIcons(context).add,
                                        color: Colors.white, size: 40),
                                    Text(
                                      'Add Image',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                    } else {
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: widget.height * .2,
                            color: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl: images[index],
                              placeholder: (context, url) => Center(
                                  child: PlatformCircularProgressIndicator()),
                              fit: BoxFit.fitHeight,
                            ),
                          ));
                    }
                  }),
            );
          }
        });
  }
}
