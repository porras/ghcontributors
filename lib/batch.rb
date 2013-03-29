class Batch < Struct.new(:batch)
  def update
    puts "Updating batch ##{batch}"
    DB.view('ghcontributors/batches', :key => batch, :include_docs => true)['rows'].each do |row|
      begin
        Repo.new(row['doc']['name'], row['doc']).update
      rescue Exception => e
        puts "Updating repo '#{row['doc']['name']}' failed with message #{e.message}"
      end
    end
    puts "Done with batch ##{batch}"
  end
end
