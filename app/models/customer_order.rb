class CustomerOrder < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :entity,  class_name: 'Entity',     foreign_key: :customer_id
  belongs_to :country, class_name: 'IsoCountry', foreign_key: :from_country_id
  belongs_to :country, class_name: 'IsoCountry', foreign_key: :to_country_id

  has_many :customer_order_events

  #
  # MIGRATION process: to import customer orders from a legacy system via Excel
  # @param file (string): name of the file containing all the data
  #
  # @return (Hash): message with the result of the import process
  #           i.e.: {
  #                   message: "Records read: 3346 / Records saved: 3178 / Check log file",
  #                   logFile: "./public/downloads/logs/migration_custorder_20180929_1101.log"
  #                 }
  #
  # This process writes a LOG file in /public/downloads/logs directory
  #
  def self.import(file)
     
     # Define variables
     recs_saved = 0
      
    if file.blank? then
      raise 'TRK-0001(E): the FILENAME cannot be empty'
    else
      # Open Excel file and set the headers
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)

      # Open de LOG file
      logFileName = 'migration_customerorders_' + Time.now().strftime('%Y%m%d_%H%M') + '.log'
      csv_record = File.open(Rails.root.to_s + ApplicationController.helpers.staticPath('log') + logFileName, "w")
       
      # Iterate over each ROW and insert the data into CustomerOrder record
      (2..spreadsheet.last_row).each do |i|
        puts '*** REGISTRO: ' + i.to_s
        row = Hash[[header, spreadsheet.row(i)].transpose]
        puts 'OLD NO: //' + row['old_order_no'] + '//'
        custorder = find_by_old_order_no((row['old_order_no'] || '')) || new
        custorder.attributes = row.to_hash.slice(*custorder.attributes.keys)

        #
        # Validate and fullfill the data
        #
        has_errors = false
        # Field company_id
        if not row['customer_name'].blank? then
          begin
            rec_entity = Entity.find_by(name: row['customer_name'])
            if rec_entity.blank? then
              csv_record.puts('Row: ' + i.to_s + ' - Customer Name not found: ' + row['customer_name'])
              has_errors = true
            else
              custorder.customer_id = rec_entity.id
              custorder.company_id  = rec_entity.company_id
            end
          rescue => e
            csv_record.puts('Row: ' + i.to_s + ' - Error finding customer in Entity table / ' + e.to_s)
            has_errors = true
          end
        else
          csv_record.puts('Row: ' + i.to_s + ' - Customer Name can not be empty.')
          has_errors = true
        end

        # Field order_no
        if custorder.order_no.blank? then
          if not custorder.company_id.blank? then
            rec_aux = CustomerOrder.order(order_no: :desc).find_by company_id: custorder.company_id
            if rec_aux.blank? then
              custorder.order_no = 1
            else
              custorder.order_no = rec_aux.order_no + 1
            end
            puts "ORDER NO:", custorder.order_no
          end
        end

        # Field order_date
        begin
          custorder.order_date = Date.strptime(row['order_date'], '%m/%d/%Y')
        rescue
          csv_record.puts('Row: ' + i.to_s + ' - order_date conversion error (mm/dd/yyyy): ' + row['order_date'] +'\n')
          has_errors = true
        end

        # Field observations
        custorder.observations = 'MIGRATION '             + Date.today().strftime('%d-%b-%Y') + '\n' \
                               + 'OLD Status: '           + row['observations_status'] + '\n' \
                               + 'OLD Type: '             + row['observations_type'] + '\n' \
                               + 'OLD LastEvent: '        + row['observations_last_event'] + '\n' \
                               + 'OLD LastInternalNote: ' + row['observations_last_internal_note'] + '\n' 

        # Field from_contact
        custorder.from_contact = row['from_contact_first_name'] +' '+ row['from_contact_last_name']

        # Field to_ontact
        custorder.to_contact = row['to_contact_first_name'] +' '+ row['to_contact_last_name']

        # Field to_country_id and from_country_id
        custorder.from_country_id = (custorder.from_country_id.blank?)? 'NNN' : custorder.from_country_id.rstrip
        custorder.to_country_id   = (custorder.to_country_id.blank?)?   'NNN' : custorder.to_country_id.rstrip
        
        # Save data
        if not has_errors then
          begin
            custorder.save!
            recs_saved += 1
          rescue => e
            csv_record.puts('Row: ' + i.to_s + ' - error saving to DBase: ' + e.to_s)
          end
        end
      end #loop
      recs_read = spreadsheet.last_row - 1

      csv_record.puts('Records read: ' + recs_read.to_s + ' / Records saved to DBase: ' + recs_saved.to_s)
      csv_record.close()

      if (recs_read == recs_saved) then
        output = {
          "message": 'Records read: ' + recs_read.to_s + ' / Records saved to DBase: ' + recs_saved.to_s,
          "logFile": ""
        }
      else
        output = {
          "message": 'Records read: ' + recs_read.to_s + ' / Records saved to DBase: ' + recs_saved.to_s + ' / Please, download and check the LOG for errors',
          "logFile": logFileName
        }
      end

      return output

    end

  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
