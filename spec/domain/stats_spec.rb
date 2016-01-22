require 'rails_helper'

class FakeRedis
  def get key; end
end

RSpec.describe Stats do
  describe '#calculate_totals' do
    context 'overall' do
      it 'returns overall totals' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.overall').and_return(10)
        expect(redis).to receive(:get).with('emails.open.overall').and_return(8)
        expect(redis).to receive(:get).with('emails.click.overall').and_return(2)

        stats = Stats.new redis
        expected = {
          total_sent: 10,
          total_opened: 8,
          total_clicks: 2
        }
        expect(stats.calculate_totals).to eq(expected)
      end
    end

    context 'passing year' do
      it 'returns totals for year' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.year:2015').and_return(10)
        expect(redis).to receive(:get).with('emails.open.year:2015').and_return(8)
        expect(redis).to receive(:get).with('emails.click.year:2015').and_return(2)

        stats = Stats.new redis
        expected = {
          total_sent: 10,
          total_opened: 8,
          total_clicks: 2
        }
        expect(stats.calculate_totals year: 2015).to eq(expected)
      end
    end

    context 'passing year and month' do
      it 'returns totals for year and month' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.year.month:2015:08').and_return(10)
        expect(redis).to receive(:get).with('emails.open.year.month:2015:08').and_return(8)
        expect(redis).to receive(:get).with('emails.click.year.month:2015:08').and_return(2)

        stats = Stats.new redis
        expected = {
          total_sent: 10,
          total_opened: 8,
          total_clicks: 2
        }
        expect(stats.calculate_totals year: 2015, month: 8).to eq(expected)
      end
    end
  end

  describe '#rates' do
    context 'overall' do
      it 'returns overall rates' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.overall').and_return(10)
        expect(redis).to receive(:get).with('emails.open.overall').and_return(8)
        expect(redis).to receive(:get).with('emails.click.overall').and_return(2)

        stats = Stats.new redis
        expected = {
          open: 80.0,
          click: 20.0
        }
        expect(stats.rates).to eq(expected)
      end
    end

    context 'passing year' do
      it 'returns rates for year' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.year:2015').and_return(10)
        expect(redis).to receive(:get).with('emails.open.year:2015').and_return(8)
        expect(redis).to receive(:get).with('emails.click.year:2015').and_return(2)

        stats = Stats.new redis
        expected = {
          open: 80.0,
          click: 20.0
        }
        expect(stats.rates year: 2015).to eq(expected)
      end
    end

    context 'passing year and month' do
      it 'returns rates for year/month' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.year.month:2015:08').and_return(10)
        expect(redis).to receive(:get).with('emails.open.year.month:2015:08').and_return(8)
        expect(redis).to receive(:get).with('emails.click.year.month:2015:08').and_return(2)

        stats = Stats.new redis
        expected = {
          open: 80.0,
          click: 20.0
        }
        expect(stats.rates year: 2015, month: 8).to eq(expected)
      end
    end

    context 'passing year, month, and email type' do
      it 'returns rates for year/month' do
        redis = FakeRedis.new
        expect(redis).to receive(:get).with('emails.send.year.month.type:2015:08:shipment').and_return(10)
        expect(redis).to receive(:get).with('emails.open.year.month.type:2015:08:shipment').and_return(8)
        expect(redis).to receive(:get).with('emails.click.year.month.type:2015:08:shipment').and_return(2)

        stats = Stats.new redis
        expected = {
          open: 80.0,
          click: 20.0
        }
        expect(stats.rates year: 2015, month: 8, email_type: :shipment).to eq(expected)
      end
    end
  end
end
