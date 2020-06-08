import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/ImageSourceModal.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageList extends StatefulWidget {
  const ImageList(
      {Key key, @required this.height, @required this.chef, this.edit})
      : super(key: key);

  final double height;
  final Chef chef;
  final bool edit;

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  Future<List<dynamic>> getImages;
  PageController pageController = PageController();

  @override
  void initState() {
    getImages = ImageFunctions().getChefsImages(widget.chef.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder<List<dynamic>>(
            future: getImages,
            builder: (context, snapshot) {
              if (!snapshot.hasData &&
                  snapshot.connectionState != ConnectionState.done) {
                return Container(
                    height: widget.height * .2,
                    child: Center(child: PlatformCircularProgressIndicator()));
              } else {
                List<dynamic> images = snapshot.data;
                if (widget.edit) {
                  if (images.length == 0) {
                    images.add('create');
                  } else if (images[images.length - 1] != 'create') {
                    images.add('create');
                  }
                }
                return Container(
                  child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        if (images[index] == 'create') {
                          return GestureDetector(
                            onTap: () async {
                              await ImageSourceModal()
                                  .showModal(context, 'chef', widget.chef.id);
                              getImages = ImageFunctions()
                                  .getChefsImages(widget.chef.images);
                              this.setState(() {});
                            },
                            child: Container(
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
                          );
                        } else {
                          // if(images != null) {
                          //   if(widget.edit && images.length-1 != widget.chef.images.length && images[images.length-1] != 'new'){
                          //     images.removeAt(images.length-1);
                          //     images.add('new');
                          //   }
                          // }
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl: images[index],
                              placeholder: (context, url) => Center(
                                  child: PlatformCircularProgressIndicator()),
                              errorWidget: (context, url, obj) => Container(
                                  color: Colors.blue, child: Text('Hello')),
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      }),
                );
              }
            }),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                  controller: pageController, 
                  count: widget.edit? widget.chef.images.length + 1 : widget.chef.images.length,
                  effect: SlideEffect(
                    activeDotColor: Colors.white,
                    spacing: 8,
                    dotHeight: 8,
                    dotWidth: 8
                  ),
                )
              ),
        )
      ],
    );
  }
}
