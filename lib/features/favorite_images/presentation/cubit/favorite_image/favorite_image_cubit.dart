import 'package:bloc/bloc.dart';
import 'package:clean_architecture/features/favorite_images/data/models/image.dart';
import 'package:clean_architecture/features/favorite_images/domain/entities/image.dart';
import 'package:clean_architecture/features/favorite_images/domain/usecases/get_image_list.dart';
import 'package:equatable/equatable.dart';

part 'favorite_image_state.dart';

class FavoriteImageCubit extends Cubit<FavoriteImageState> {
  final GetImageListUseCase _getImageListUseCase;

  FavoriteImageCubit(this._getImageListUseCase)
      : super(FavoriteImageInitial()) {
    _getImageList();
  }

  void _getImageList() async {
    try {
      final data = await _getImageListUseCase();
      final List<ImageEntity> favoriteList = [];
      favoriteList.addAll(data.where((item) => item.like == true));
      emit(FavoriteImageLoaded(imageList: data));
    } catch (e) {
      emit(const FavoriteImageError('Failed to load images'));
    }
  }

  void changeLike(int index) {
    if (state is FavoriteImageLoaded) {
      print("Click");
      final currentState = state as FavoriteImageLoaded;
      final List<ImageEntity> imageList = currentState.imageList;

      //Change like
      final bool likeState = imageList[index].like!;
      ImageEntity changeImage = ImageModel(
          id: imageList[index].id,
          name: imageList[index].name,
          image: imageList[index].image,
          like: !likeState);
      imageList[index] = changeImage;

      emit(FavoriteImageLoaded(imageList: imageList));
    }
  }
}
