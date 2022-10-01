import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/address_model.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/location_provider.dart';
import 'package:mechatronia_app/provider/order_provider.dart';
import 'package:mechatronia_app/provider/profile_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/button/custom_button.dart';
import 'package:mechatronia_app/view/basewidget/custom_app_bar.dart';
import 'package:mechatronia_app/view/basewidget/my_dialog.dart';
import 'package:mechatronia_app/view/basewidget/textfield/custom_textfield.dart';
import 'package:mechatronia_app/view/screen/address/select_location_screen.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  final bool isBilling;
  AddNewAddressScreen({this.isEnableUpdate = false, this.address, this.fromCheckout = false, this.isBilling});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  String _city;
  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipNode = FocusNode();
  GoogleMapController _controller;
  CameraPosition _cameraPosition;
  bool _updateAddress = true;

  @override
  void initState() {
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false).updateErrorMessage(message: '');
    _checkPermission(
        () => Provider.of<LocationProvider>(context, listen: false)
            .getCurrentLocation(context, true, mapController: _controller),
        context);
    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false).updatePosition(
          CameraPosition(target: LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude))),
          true,
          widget.address.address,
          context);
      _contactPersonNameController.text = '${widget.address.contactPersonName}';
      _contactPersonNumberController.text = '${widget.address.phone}';
      if (widget.address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0, false);
      } else if (widget.address.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(1, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(2, false);
      }
    } else {
      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
        _contactPersonNameController.text =
            '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}'
            ' ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName ?? ''}';
        _contactPersonNumberController.text =
            Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    final areaList = Provider.of<SplashProvider>(context, listen: false).configModel.areaList;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                  title: widget.isEnableUpdate
                      ? getTranslated('update_address', context)
                      : getTranslated('add_new_address', context)),
              Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Center(
                                child: SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 126,
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              GoogleMap(
                                                mapType: MapType.normal,
                                                initialCameraPosition: CameraPosition(
                                                  target: widget.isEnableUpdate
                                                      ? LatLng(double.parse(widget.address.latitude) ?? 0.0,
                                                          double.parse(widget.address.longitude) ?? 0.0)
                                                      : LatLng(locationProvider.position.latitude ?? 0.0,
                                                          locationProvider.position.longitude ?? 0.0),
                                                  zoom: 17,
                                                ),
                                                onTap: (latLng) {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          SelectLocationScreen(googleMapController: _controller)));
                                                },
                                                zoomControlsEnabled: false,
                                                compassEnabled: false,
                                                indoorViewEnabled: true,
                                                mapToolbarEnabled: false,
                                                onCameraIdle: () {
                                                  if (_updateAddress) {
                                                    locationProvider.updatePosition(
                                                        _cameraPosition, true, null, context);
                                                  } else {
                                                    _updateAddress = true;
                                                  }
                                                },
                                                onCameraMove: ((_position) => _cameraPosition = _position),
                                                onMapCreated: (GoogleMapController controller) {
                                                  _controller = controller;
                                                  if (!widget.isEnableUpdate && _controller != null) {
                                                    Provider.of<LocationProvider>(context, listen: false)
                                                        .getCurrentLocation(context, true, mapController: _controller);
                                                  }
                                                },
                                              ),
                                              locationProvider.loading
                                                  ? Center(
                                                      child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(
                                                              Theme.of(context).primaryColor)))
                                                  : SizedBox(),
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  alignment: Alignment.center,
                                                  height: MediaQuery.of(context).size.height,
                                                  child: Icon(
                                                    Icons.location_on,
                                                    size: 40,
                                                    color: Theme.of(context).primaryColor,
                                                  )),
                                              Positioned(
                                                bottom: 10,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    _checkPermission(
                                                        () => locationProvider.getCurrentLocation(context, true,
                                                            mapController: _controller),
                                                        context);
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                      color: ColorResources.getChatIcon(context),
                                                    ),
                                                    child: Icon(
                                                      Icons.my_location,
                                                      color: Theme.of(context).primaryColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (BuildContext context) =>
                                                            SelectLocationScreen(googleMapController: _controller)));
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                      color: Colors.white,
                                                    ),
                                                    child: Icon(
                                                      Icons.fullscreen,
                                                      color: Theme.of(context).primaryColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Center(
                                            child: Text(
                                          getTranslated('add_the_location_correctly', context),
                                          style: Theme.of(context).textTheme.headline2.copyWith(
                                              color: ColorResources.getTextTitle(context),
                                              fontSize: Dimensions.FONT_SIZE_SMALL),
                                        )),
                                      ),

                                      // for label us
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                                        child: Text(
                                          getTranslated('label_us', context),
                                          style: Theme.of(context).textTheme.headline3.copyWith(
                                              color: ColorResources.getHint(context),
                                              fontSize: Dimensions.FONT_SIZE_LARGE),
                                        ),
                                      ),

                                      Container(
                                        height: 50,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: locationProvider.getAllAddressType.length,
                                          itemBuilder: (context, index) => InkWell(
                                            onTap: () {
                                              locationProvider.updateAddressIndex(index, true);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimensions.PADDING_SIZE_DEFAULT,
                                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                                              margin: EdgeInsets.only(right: 17),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                    Dimensions.PADDING_SIZE_SMALL,
                                                  ),
                                                  border: Border.all(
                                                      color: locationProvider.selectAddressIndex == index
                                                          ? Theme.of(context).primaryColor
                                                          : ColorResources.getHint(context)),
                                                  color: locationProvider.selectAddressIndex == index
                                                      ? Theme.of(context).primaryColor
                                                      : ColorResources.getChatIcon(context)),
                                              child: Text(
                                                getTranslated(
                                                    locationProvider.getAllAddressType[index].toLowerCase(), context),
                                                style: robotoRegular.copyWith(
                                                    color: locationProvider.selectAddressIndex == index
                                                        ? Theme.of(context).cardColor
                                                        : ColorResources.getHint(context)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                                        child: Text(
                                          getTranslated('delivery_address', context),
                                          style: Theme.of(context).textTheme.headline3.copyWith(
                                              color: ColorResources.getHint(context),
                                              fontSize: Dimensions.FONT_SIZE_LARGE),
                                        ),
                                      ),

                                      // for Address Field
                                      Text(
                                        getTranslated('address_line_01', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('address_line_02', context),
                                        textInputType: TextInputType.streetAddress,
                                        textInputAction: TextInputAction.next,
                                        focusNode: _addressNode,
                                        nextNode: _nameNode,
                                        controller: locationProvider.locationController,
                                      ),
                                      Text(
                                        getTranslated('city', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField<String>(
                                              focusNode: _cityNode,
                                              decoration: InputDecoration(hintText: getTranslated('city', context)),
                                              items: areaList
                                                  .map((e) => DropdownMenuItem(
                                                        child: Text(
                                                          e.name,
                                                        ),
                                                        value: e.id?.toString() ?? "",
                                                      ))
                                                  .toList(),
                                              onChanged: (newValue) {
                                                _city = newValue;
                                              })),
                                      /* CustomTextField(
                                        hintText: getTranslated('city', context),
                                        textInputType: TextInputType.streetAddress,
                                        textInputAction: TextInputAction.next,
                                        focusNode: _cityNode,
                                        nextNode: _zipNode,
                                        controller: _cityController,
                                      ), */
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        getTranslated('zip', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('zip', context),
                                        textInputType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        focusNode: _zipNode,
                                        nextNode: _nameNode,
                                        controller: _zipCodeController,
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                      // for Contact Person Name
                                      Text(
                                        getTranslated('contact_person_name', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('enter_contact_person_name', context),
                                        textInputType: TextInputType.name,
                                        controller: _contactPersonNameController,
                                        focusNode: _nameNode,
                                        nextNode: _numberNode,
                                        textInputAction: TextInputAction.next,
                                        capitalization: TextCapitalization.words,
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                      // for Contact Person Number
                                      Text(
                                        getTranslated('contact_person_number', context),
                                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('enter_contact_person_number', context),
                                        textInputType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        focusNode: _numberNode,
                                        controller: _contactPersonNumberController,
                                      ),

                                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        locationProvider.addressStatusMessage != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  locationProvider.addressStatusMessage.length > 0
                                      ? CircleAvatar(backgroundColor: Colors.green, radius: 5)
                                      : SizedBox.shrink(),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      locationProvider.addressStatusMessage ?? "",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
                                    ),
                                  )
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  locationProvider.errorMessage.length > 0
                                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                      : SizedBox.shrink(),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      locationProvider.errorMessage ?? "",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: Theme.of(context).primaryColor,
                                          height: 1),
                                    ),
                                  )
                                ],
                              ),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: !locationProvider.isLoading
                              ? CustomButton(
                                  buttonText: widget.isEnableUpdate
                                      ? getTranslated('update_address', context)
                                      : getTranslated('save_location', context),
                                  onTap: locationProvider.loading
                                      ? null
                                      : () {
                                          AddressModel addressModel = AddressModel(
                                            addressType:
                                                locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                                            contactPersonName: _contactPersonNameController.text ?? '',
                                            phone: _contactPersonNumberController.text ?? '',
                                            city: _city ?? '',
                                            zip: _zipCodeController.text ?? '',
                                            isBilling: widget.isBilling ? 1 : 0,
                                            address: locationProvider.locationController.text ?? '',
                                            latitude: widget.isEnableUpdate
                                                ? locationProvider.position.latitude.toString() ??
                                                    widget.address.latitude
                                                : locationProvider.position.latitude.toString() ?? '',
                                            longitude: widget.isEnableUpdate
                                                ? locationProvider.position.longitude.toString() ??
                                                    widget.address.longitude
                                                : locationProvider.position.longitude.toString() ?? '',
                                          );
                                          if (widget.isEnableUpdate) {
                                            addressModel.id = widget.address.id;
                                            addressModel.id = widget.address.id;
                                            // addressModel.method = 'put';
                                            locationProvider
                                                .updateAddress(context,
                                                    addressModel: addressModel, addressId: addressModel.id)
                                                .then((value) {});
                                          } else {
                                            locationProvider.addAddress(addressModel, context).then((value) {
                                              if (value.isSuccess) {
                                                Provider.of<ProfileProvider>(context, listen: false)
                                                    .initAddressList(context);
                                                Navigator.pop(context);
                                                if (widget.fromCheckout) {
                                                  Provider.of<ProfileProvider>(context, listen: false)
                                                      .initAddressList(context);
                                                  Provider.of<OrderProvider>(context, listen: false)
                                                      .setAddressIndex(-1);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text(value.message),
                                                      duration: Duration(milliseconds: 600),
                                                      backgroundColor: Colors.green));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text(value.message),
                                                    duration: Duration(milliseconds: 600),
                                                    backgroundColor: Colors.red));
                                              }
                                            });
                                          }
                                        },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                )),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.whileInUse) {
      InkWell(
          onTap: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
            _checkPermission(callback, context);
          },
          child: AlertDialog(
              content: MyDialog(
                  icon: Icons.location_on_outlined, title: '', description: getTranslated('you_denied', context))));
    } else if (permission == LocationPermission.deniedForever) {
      InkWell(
          onTap: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
            _checkPermission(callback, context);
          },
          child: AlertDialog(
              content: MyDialog(
                  icon: Icons.location_on_outlined, title: '', description: getTranslated('you_denied', context))));
    } else {
      callback();
    }
  }
}
