class Batch < Struct.new(:batch)
  def update
    puts "Updating batch ##{batch}"
    DB.view('ghcontributors/batches', :key => batch, :include_docs => true)['rows'].each do |row|
      Repo.new(row['doc']['name'], row['doc']).update
    end
  end
end
