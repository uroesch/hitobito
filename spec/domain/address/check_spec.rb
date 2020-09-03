# encoding: utf-8

#  Copyright (c) 2012-2020, CVP Schweiz. This file is part of
#  hitobito_cvp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cvp.

require 'spec_helper'

describe Address::Check do

  def create_person(*args)
    build_person(*args).tap(&:save!)
  end

  def build_person(*args)
    Fabricate.build(:person_with_address, {
      address: args.first,
      town: args.second,
      zip_code: args.third
    })
  end

  def check(*args)
    Address::Check.new(build_person(*args))
  end

  it 'is blank if address fields are blank' do
    expect(check('', '', nil).state).to eq :missing
  end

  it 'is partial if some address fields are missing' do
    expect(check('Belpstrasse', '', 3007).state).to eq :partial
  end

  context 'valid' do
    it 'exact match' do
      expect(check('Belpstrasse 37', 'Bern', 3007).state).to eq :valid
    end

    it 'lower case street name' do
      expect(check('belpstrasse 37', 'Bern', 3007).state).to eq :valid
    end

    it 'lower case town name' do
      expect(check('belpstrasse 37', 'bern', 3007).state).to eq :valid
    end
  end

  context 'invalid' do
    it 'invalid street name' do
      expect(check('belpstr. 35', 'bern', 3007).state).to eq :invalid
    end

    it 'invalid number' do
      expect(check('belpstrasse 35', 'bern', 3007).state).to eq :invalid
    end

    it 'invalid town' do
      expect(check('Belpstrasse 37', 'Zürich', 3007).state).to eq :invalid
    end

    it 'invalid zip_code' do
      expect(check('Belpstrasse 37', 'Bern', 3006).state).to eq :invalid
    end
  end

  context 'check!' do
    it 'assigns partial tag' do
      person = create_person('', '', nil)
      Address::Check.new(person).run
      expect(person.tags.first.name).to eq 'address:missing'
    end

    it 'does not retag tagged person partial tag' do
      person = create_person('', '', nil)
      person.tag_list.add('address:missing')
      Address::Check.new(person).run
      expect(person.tags.first.name).to eq 'address:missing'
    end
  end
end
