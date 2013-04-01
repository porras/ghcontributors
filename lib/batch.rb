class Batch < Struct.new(:batch)
  def update
    OUT.puts "Updating batch ##{batch}"
    DB.view('ghcontributors/batches', :key => batch, :include_docs => true)['rows'].each do |row|
      begin
        Repo.new(row['doc']['name'], row['doc']).update(bulk: true)
        @updated = true
      rescue Exception => e
        OUT.puts "Updating repo '#{row['doc']['name']}' failed with message #{e.message}"
      end
    end
    DB.bulk_save if @updated
    OUT.puts "Done with batch ##{batch}"
  end
end
