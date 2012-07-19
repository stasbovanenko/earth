# encoding: UTF-8

require 'spec_helper'
require 'earth/locality/country'

describe Country do
  describe 'import', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      Country.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    let(:us) { Country.united_states }
    let(:uk) { Country.find 'GB' }
    
    it { Country.count.should == 249 }
    
    describe 'uses UTF-8 encoding' do
      it { Country.find('AX').name.should == "Åland Islands" }
      it { Country.find('CI').name.should == "Côte d'Ivoire" }
    end
    
    it { Country.where('heating_degree_days >= 0 AND cooling_degree_days > 0').count.should == 173 }
    
    describe 'US automobile data' do
      it { us.automobile_urbanity.should == 0.43 }
      it { us.automobile_city_speed.should be_within(5e-5).of(32.0259) }
      it { us.automobile_highway_speed.should be_within(5e-5).of(91.8935) }
      it { us.automobile_trip_distance.should be_within(5e-5).of(16.3348) }
    end
    
    describe 'flight data' do
      it { Country.where("flight_route_inefficiency_factor > 0").count.should == 17 }
      it { us.flight_route_inefficiency_factor.should == 1.07 }
      it { uk.flight_route_inefficiency_factor.should == 1.1 }
    end
    
    describe 'lodging data' do
      it { us.lodging_occupancy_rate.should be_within(5e-4).of(0.601) }
      it { us.lodging_natural_gas_intensity.should be_within(5e-3).of(62.06) }
      it { us.lodging_natural_gas_intensity_units.should == 'megajoules_per_room_night' }
    end
    
    describe 'rail data' do
      it { Country.where("rail_passengers > 0").count.should == 26 }
      it { Country.where("rail_trip_distance > 0").count.should == 26 }
      it { Country.where("rail_trip_electricity_intensity > 0").count.should == 26 }
      it { Country.where("rail_trip_diesel_intensity > 0").count.should == 26 }
      it { Country.where("rail_trip_co2_emission_factor > 0").count.should == 26 }
      
      # spot checks
      it { us.rail_passengers.should be_within(10_000).of(4_466_991_391) }
      it { us.rail_trip_distance.should be_within(5e-5).of(12.9952) }
      it { us.rail_speed.should be_within(5e-5).of(32.4972) }
      it { us.rail_trip_electricity_intensity.should be_within(5e-5).of(0.14051) }
      it { us.rail_trip_diesel_intensity.should be_within(5e-5).of(0.01942) }
      it { us.rail_trip_co2_emission_factor.should be_within(5e-5).of(0.0909) }
      
      it { uk.rail_passengers.should == 1352150000 }
      it { uk.rail_trip_distance.should be_within(5e-5).of(40.6904) }
      it { uk.rail_trip_electricity_intensity.should be_within(5e-5).of(0.09) }
      it { uk.rail_trip_diesel_intensity.should be_within(5e-5).of(0.0028) }
      it { uk.rail_trip_co2_emission_factor.should be_within(5e-5).of(0.0458) }
    end
  end
  
  describe '.united_states' do
    it 'should return the United States' do
      Country.united_states.should == Country.find('US')
    end
  end
  
  describe '.fallback' do
    let(:fallback) { Country.fallback }
    it { fallback.name.should == 'fallback' }
    it { fallback.electricity_mix.should == ElectricityMix.fallback }
  end
end
