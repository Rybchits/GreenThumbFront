import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

class SpaceCardInfo extends Space {
  int numberPlants = 0;

  SpaceCardInfo( { required int idSpace, required User creatorSpace, required String nameSpace, String? imageUrlSpace,
    required List<String> tagsSpace, required numberPlantsSpace} ) {
    tags = tagsSpace;
    id = idSpace;
    creator = creatorSpace;
    name = nameSpace;
    imageUrl = imageUrlSpace;
    numberPlants = numberPlantsSpace;
  }

  factory SpaceCardInfo.fromSpaceDetails(SpaceDetails details){
        return SpaceCardInfo(
        idSpace: details.id,
        creatorSpace: details.creator,
        nameSpace: details.name,
        imageUrlSpace: details.imageUrl,
        tagsSpace: details.tags,
        numberPlantsSpace: details.plants.length);
  }
}