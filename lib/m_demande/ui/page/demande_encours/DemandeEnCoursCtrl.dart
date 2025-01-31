import 'package:odc_mobile_project/m_demande/business/model/Demande.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../m_user/business/interactor/UserInteractor.dart';
import '../../../business/interactor/demandeInteractor.dart';
import 'demandeEnCoursState.dart';

part 'DemandeEnCoursCtrl.g.dart';

@riverpod
class DemandeEnCoursCtrl extends _$DemandeEnCoursCtrl {
  @override
  DemandeEnCoursState build() {
    return DemandeEnCoursState();
  }

  void nombreDemande() async {
    state = state.copyWith(isLoading: true, visible: true);
    List<Demande> demandes = [];
    var usecase = ref.watch(demandeInteractorProvider).nombreDemandeUseCase;
    var res = await usecase.run();
    var data = res['demandes_encours'];
    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      demandes.add(Demande.fromJson(item));
    }
    if (demandes.length != 0) {
      state = state.copyWith(
          demande: demandes,
          listDemandesSearch: demandes,
          nbrDemande: demandes.length,
          isLoading: false,
          visible: false,
          notFound: true);
    } else {
      state = state.copyWith(
          isLoading: false, isEmpty: true, nbrDemande: 0, visible: true);
    }
  }

  void getUser() async {
    var usecase = ref.watch(userInteractorProvider).getUserLocalUseCase;
    var res = await usecase.run();
    state = state.copyWith(user: res);
  }

  void filtre(String recherche) async {
    List<Demande> demandes = state.demande;

    List<Demande> demandesCorrespondant = demandes
        .where((demande) => demande.motif.toLowerCase().contains(recherche))
        .toList();
    state = state.copyWith(listDemandesSearch: demandesCorrespondant);

    if (demandesCorrespondant.length != 0) {
      state = state.copyWith(notFound: true);
    } else {
      state = state.copyWith(notFound: false);
    }
  }
}
