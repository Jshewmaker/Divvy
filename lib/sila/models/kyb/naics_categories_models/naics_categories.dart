import 'package:equatable/equatable.dart';
import "accommodation_and_food_services.dart";
import "administrative_and_support_and_waste_management_and_remediation.dart";
import "agriculture_forestry_fishing_and_hunting.dart";
import "arts_entertainment_and_recreation.dart";
import "construction.dart";
import "educational_services.dart";
import "finance_and_insurance.dart";
import "health_care_and_social_assistance.dart";
import "information.dart";
import "management_of_companies_and_enterprises.dart";
import "manufacturing.dart";
import "mining_quarrying_and_oil_and_gas_extraction.dart";
import "other_services_except_public_administration.dart";
import "professional_scientific_and_technical_services.dart";
import "public_administration.dart";
import "real_estate_and_rental_and_leasing.dart";
import "retail_trade.dart";
import "transportation_and_warehousing.dart";
import "utilities.dart";
import "wholesale_trade.dart";

class NaicsCategories extends Equatable {
  final List<AccommodationAndFoodServices> accommodationAndFoodServices;
  final List<AdministrativeAndSupportAndWasteManagementAndRemediation>
      administrativeAndSupportAndWasteManagementAndRemediation;
  final List<AgricultureForestryFishingAndHunting>
      agricultureForestryFishingAndHunting;
  final List<ArtsEntertainmentAndRecreation> artsEntertainmentAndRecreation;
  final List<Construction> construction;
  final List<EducationalServices> educationalServices;
  final List<FinanceAndInsurance> financeAndInsurance;
  final List<HealthCareAndSocialAssistance> healthCareAndSocialAssistance;
  final List<Information> information;
  final List<ManagementOfCompaniesAndEnterprises>
      managementOfCompaniesAndEnterprises;
  final List<Manufacturing> manufacturing;
  final List<MiningQuarryingAndOilAndGasExtraction>
      miningQuarryingAndOilAndGasExtraction;
  final List<OtherServicesExceptPublicAdministration>
      otherServicesExceptPublicAdministration;
  final List<ProfessionalScientificAndTechnicalServices>
      professionalScientificAndTechnicalServices;
  final List<PublicAdministration> publicAdministration;
  final List<RealEstateAndRentalAndLeasing> realEstateAndRentalAndLeasing;
  final List<RetailTrade> retailTrade;
  final List<TransportationAndWarehousing> transportationAndWarehousing;
  final List<Utilities> utilities;
  final List<WholesaleTrade> wholesaleTrade;

  NaicsCategories(
      {this.accommodationAndFoodServices,
      this.administrativeAndSupportAndWasteManagementAndRemediation,
      this.agricultureForestryFishingAndHunting,
      this.artsEntertainmentAndRecreation,
      this.construction,
      this.educationalServices,
      this.financeAndInsurance,
      this.healthCareAndSocialAssistance,
      this.information,
      this.managementOfCompaniesAndEnterprises,
      this.manufacturing,
      this.miningQuarryingAndOilAndGasExtraction,
      this.otherServicesExceptPublicAdministration,
      this.professionalScientificAndTechnicalServices,
      this.publicAdministration,
      this.realEstateAndRentalAndLeasing,
      this.retailTrade,
      this.transportationAndWarehousing,
      this.utilities,
      this.wholesaleTrade});

  factory NaicsCategories.fromJson(Map<String, dynamic> json) {
    return NaicsCategories(
      accommodationAndFoodServices:
          json['Accommodation and Food Services'] != null
              ? json['Accommodation and Food Services']
                  .map<AccommodationAndFoodServices>(
                      (v) => new AccommodationAndFoodServices.fromJson(v))
                  .toList()
              : null,
      administrativeAndSupportAndWasteManagementAndRemediation: json[
                  'Administrative and Support and Waste Management and Remediation'] !=
              null
          ? json['Administrative and Support and Waste Management and Remediation']
              .map<AdministrativeAndSupportAndWasteManagementAndRemediation>(
                  (v) =>
                      new AdministrativeAndSupportAndWasteManagementAndRemediation
                          .fromJson(v))
              .toList()
          : null,
      agricultureForestryFishingAndHunting:
          json['Agriculture, Forestry, Fishing and Hunting'] != null
              ? json['Agriculture, Forestry, Fishing and Hunting']
                  .map<AgricultureForestryFishingAndHunting>((v) =>
                      new AgricultureForestryFishingAndHunting.fromJson(v))
                  .toList()
              : null,
      artsEntertainmentAndRecreation:
          json['Arts, Entertainment, and Recreation'] != null
              ? json['Arts, Entertainment, and Recreation']
                  .map<ArtsEntertainmentAndRecreation>(
                      (v) => new ArtsEntertainmentAndRecreation.fromJson(v))
                  .toList()
              : null,
      construction: json['Construction'] != null
          ? json['Construction']
              .map<Construction>((v) => new Construction.fromJson(v))
              .toList()
          : null,
      educationalServices: json['Educational Services'] != null
          ? json['Educational Services']
              .map<EducationalServices>(
                  (v) => new EducationalServices.fromJson(v))
              .toList()
          : null,
      financeAndInsurance: json['Finance and Insurance'] != null
          ? json['Finance and Insurance']
              .map<FinanceAndInsurance>(
                  (v) => new FinanceAndInsurance.fromJson(v))
              .toList()
          : null,
      healthCareAndSocialAssistance:
          json['Health Care and Social Assistance'] != null
              ? json['Health Care and Social Assistance']
                  .map<HealthCareAndSocialAssistance>(
                      (v) => new HealthCareAndSocialAssistance.fromJson(v))
                  .toList()
              : null,
      information: json['Information'] != null
          ? json['Information']
              .map<Information>((v) => new Information.fromJson(v))
              .toList()
          : null,
      managementOfCompaniesAndEnterprises:
          json['Management of Companies and Enterprises'] != null
              ? json['Management of Companies and Enterprises']
                  .map<ManagementOfCompaniesAndEnterprises>((v) =>
                      new ManagementOfCompaniesAndEnterprises.fromJson(v))
                  .toList()
              : null,
      manufacturing: json['Manufacturing'] != null
          ? json['Manufacturing']
              .map<Manufacturing>((v) => new Manufacturing.fromJson(v))
              .toList()
          : null,
      miningQuarryingAndOilAndGasExtraction:
          json['Mining, Quarrying, and Oil and Gas Extraction'] != null
              ? json['Mining, Quarrying, and Oil and Gas Extraction']
                  .map<MiningQuarryingAndOilAndGasExtraction>((v) =>
                      new MiningQuarryingAndOilAndGasExtraction.fromJson(v))
                  .toList()
              : null,
      otherServicesExceptPublicAdministration:
          json['Other Services (except Public Administration)'] != null
              ? json['Other Services (except Public Administration)']
                  .map<OtherServicesExceptPublicAdministration>((v) =>
                      new OtherServicesExceptPublicAdministration.fromJson(v))
                  .toList()
              : null,
      professionalScientificAndTechnicalServices:
          json['Professional, Scientific, and Technical Services'] != null
              ? json['Professional, Scientific, and Technical Services']
                  .map<ProfessionalScientificAndTechnicalServices>((v) =>
                      new ProfessionalScientificAndTechnicalServices.fromJson(
                          v))
                  .toList()
              : null,
      publicAdministration: json['Public Administration'] != null
          ? json['Public Administration']
              .map<PublicAdministration>(
                  (v) => new PublicAdministration.fromJson(v))
              .toList()
          : null,
      realEstateAndRentalAndLeasing:
          json['Real Estate and Rental and Leasing'] != null
              ? json['Real Estate and Rental and Leasing']
                  .map<RealEstateAndRentalAndLeasing>(
                      (v) => new RealEstateAndRentalAndLeasing.fromJson(v))
                  .toList()
              : null,
      retailTrade: json['Retail Trade'] != null
          ? json['Retail Trade']
              .map<RetailTrade>((v) => new RetailTrade.fromJson(v))
              .toList()
          : null,
      transportationAndWarehousing:
          json['Transportation and Warehousing'] != null
              ? json['Transportation and Warehousing']
                  .map<TransportationAndWarehousing>(
                      (v) => new TransportationAndWarehousing.fromJson(v))
                  .toList()
              : null,
      utilities: json['Utilities'] != null
          ? json['Utilities']
              .map<Utilities>((v) => new Utilities.fromJson(v))
              .toList()
          : null,
      wholesaleTrade: json['Wholesale Trade'] != null
          ? json['Wholesale Trade']
              .map<WholesaleTrade>((v) => new WholesaleTrade.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accommodationAndFoodServices != null) {
      data['Accommodation and Food Services'] =
          this.accommodationAndFoodServices.map((v) => v.toJson()).toList();
    }
    if (this.administrativeAndSupportAndWasteManagementAndRemediation != null) {
      data['Administrative and Support and Waste Management and Remediation'] =
          this
              .administrativeAndSupportAndWasteManagementAndRemediation
              .map((v) => v.toJson())
              .toList();
    }
    if (this.agricultureForestryFishingAndHunting != null) {
      data['Agriculture, Forestry, Fishing and Hunting'] = this
          .agricultureForestryFishingAndHunting
          .map((v) => v.toJson())
          .toList();
    }
    if (this.artsEntertainmentAndRecreation != null) {
      data['Arts, Entertainment, and Recreation'] =
          this.artsEntertainmentAndRecreation.map((v) => v.toJson()).toList();
    }
    if (this.construction != null) {
      data['Construction'] = this.construction.map((v) => v.toJson()).toList();
    }
    if (this.educationalServices != null) {
      data['Educational Services'] =
          this.educationalServices.map((v) => v.toJson()).toList();
    }
    if (this.financeAndInsurance != null) {
      data['Finance and Insurance'] =
          this.financeAndInsurance.map((v) => v.toJson()).toList();
    }
    if (this.healthCareAndSocialAssistance != null) {
      data['Health Care and Social Assistance'] =
          this.healthCareAndSocialAssistance.map((v) => v.toJson()).toList();
    }
    if (this.information != null) {
      data['Information'] = this.information.map((v) => v.toJson()).toList();
    }
    if (this.managementOfCompaniesAndEnterprises != null) {
      data['Management of Companies and Enterprises'] = this
          .managementOfCompaniesAndEnterprises
          .map((v) => v.toJson())
          .toList();
    }
    if (this.manufacturing != null) {
      data['Manufacturing'] =
          this.manufacturing.map((v) => v.toJson()).toList();
    }
    if (this.miningQuarryingAndOilAndGasExtraction != null) {
      data['Mining, Quarrying, and Oil and Gas Extraction'] = this
          .miningQuarryingAndOilAndGasExtraction
          .map((v) => v.toJson())
          .toList();
    }
    if (this.otherServicesExceptPublicAdministration != null) {
      data['Other Services (except Public Administration)'] = this
          .otherServicesExceptPublicAdministration
          .map((v) => v.toJson())
          .toList();
    }
    if (this.professionalScientificAndTechnicalServices != null) {
      data['Professional, Scientific, and Technical Services'] = this
          .professionalScientificAndTechnicalServices
          .map((v) => v.toJson())
          .toList();
    }
    if (this.publicAdministration != null) {
      data['Public Administration'] =
          this.publicAdministration.map((v) => v.toJson()).toList();
    }
    if (this.realEstateAndRentalAndLeasing != null) {
      data['Real Estate and Rental and Leasing'] =
          this.realEstateAndRentalAndLeasing.map((v) => v.toJson()).toList();
    }
    if (this.retailTrade != null) {
      data['Retail Trade'] = this.retailTrade.map((v) => v.toJson()).toList();
    }
    if (this.transportationAndWarehousing != null) {
      data['Transportation and Warehousing'] =
          this.transportationAndWarehousing.map((v) => v.toJson()).toList();
    }
    if (this.utilities != null) {
      data['Utilities'] = this.utilities.map((v) => v.toJson()).toList();
    }
    if (this.wholesaleTrade != null) {
      data['Wholesale Trade'] =
          this.wholesaleTrade.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [
        this.accommodationAndFoodServices,
        this.administrativeAndSupportAndWasteManagementAndRemediation,
        this.agricultureForestryFishingAndHunting,
        this.artsEntertainmentAndRecreation,
        this.construction,
        this.educationalServices,
        this.financeAndInsurance,
        this.healthCareAndSocialAssistance,
        this.information,
        this.managementOfCompaniesAndEnterprises,
        this.manufacturing,
        this.miningQuarryingAndOilAndGasExtraction,
        this.otherServicesExceptPublicAdministration,
        this.professionalScientificAndTechnicalServices,
        this.publicAdministration,
        this.realEstateAndRentalAndLeasing,
        this.retailTrade,
        this.transportationAndWarehousing,
        this.utilities,
        this.wholesaleTrade
      ];
}
