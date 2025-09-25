import 'package:a_to_z_dto/FilterDTO/customer_favorite_store_filter_dto.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_favorite_stores_provider.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/StoreWidgets/customer_store_suggestion_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerFavoriteStoresUi extends StatefulWidget {
  const CustomerFavoriteStoresUi({super.key});

  @override
  State<CustomerFavoriteStoresUi> createState() {
    return _CustomerFavoriteStoresUi();
  }
}

class _CustomerFavoriteStoresUi extends State<CustomerFavoriteStoresUi> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadStores();
        }
      });

      await _loadStores();
    });
  }

  Future<void> _loadStores() async {
    await context.read<PVCustomerFavoriteStores>().getCustomersFavoriteStores(
      ClsCustomerFavoriteStoreFilterDTO(
        customerID:
            context
                .read<PVBaseCurrentLoginInfo>()
                .retrivingLoggedInDTO!
                .branchID,
        pageSize: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Consumer<PVCustomerFavoriteStores>(
            builder: (con, value, child) {
              return CardsTemplate(
                scrollController: _scrollController,
                isLoaded: value.isLoaded,
                isFinished: value.isFinished,
                values: value.customerStoresSuggestions,
                lineLength: 2,
                widgetGetter: GetCustomerStoreSuggestionWidget(),
                onCardClick: (c) {
                  ClsCustomerStoreSuggestionDTO customerStoreSuggestionDTO =
                      c as ClsCustomerStoreSuggestionDTO;

                  if (customerStoreSuggestionDTO.storeID == null) {
                    return;
                  }

                  OpenScreens.openStoreCategoriesScreen(
                    context,
                    customerStoreSuggestionDTO,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
