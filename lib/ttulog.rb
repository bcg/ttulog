require 'bindata'

module TokyoTyrant
  module Const
    TCULMAGICNUM   = 0xc9

    TTMAGICNUM     = 0xc8
    TTCMDPUT       = 0x10
    TTCMDPUTKEEP   = 0x11 
    TTCMDPUTCAT    = 0x12 
    TTCMDPUTSHL    = 0x13 
    TTCMDPUTNR     = 0x18 
    TTCMDOUT       = 0x20 
    TTCMDGET       = 0x30 
    TTCMDMGET      = 0x31 
    TTCMDVSIZ      = 0x38 
    TTCMDITERINIT  = 0x50 
    TTCMDITERNEXT  = 0x51 
    TTCMDFWMKEYS   = 0x58 
    TTCMDADDINT    = 0x60 
    TTCMDADDDOUBLE = 0x61
    TTCMDEXT       = 0x68 
    TTCMDSYNC      = 0x70 
    TTCMDOPTIMIZE  = 0x71 
    TTCMDVANISH    = 0x72 
    TTCMDCOPY      = 0x73 
    TTCMDRESTORE   = 0x74 
    TTCMDSETMST    = 0x78 
    TTCMDRNUM      = 0x80 
    TTCMDSIZE      = 0x81 
    TTCMDSTAT      = 0x88 
    TTCMDMISC      = 0x90 
    TTCMDREPL      = 0xa0 
  end
end

TT = TokyoTyrant

module TokyoTyrant
  include TokyoTyrant::Const

  module Ulog

    def self.open(file)
      File.open(file, 'r') do |io|
        rec = cmd = nil
        loop do
          begin
            rec = TokyoTyrant::Ulog::Record.read(io)
            cmd = TokyoTyrant::Ulog::Record::Command.read(rec.body.to_s)
            yield rec, cmd
          rescue EOFError
            break
          end
        end      
      end
    end

    class Record < BinData::Record
      endian :big
      uint8  :magic
      uint64 :ts
      uint32 :sid
      uint32 :bsize
      string :body, :read_length => :bsize

      class Command < BinData::Record

        class MiscCmd < BinData::Primitive
          endian  :big
          uint32  :nsize
          uint32  :lsize
          string  :name, :read_length => :nsize

          def get;   self.name; end
          def set(v) self.name = v; end
        end

        class PutCmd < BinData::Primitive
          endian  :big
          uint32  :ksize
          uint32  :vsize
          string  :key, :read_length => :ksize
          string  :val, :read_length => :vsize

          def get;   {:key => self.key, :val => self.val}; end
          def set(v) self.key = v[:key]; self.val = v[:val]; end
        end

        endian        :big
        uint8         :magic
        uint8         :cmdt
        misc_cmd      :misc, :onlyif => lambda { is_cmd?(:misc, TT::TTCMDMISC) }
        put_cmd       :put,  :onlyif => lambda { is_cmd?(:put, TT::TTCMDPUT) or 
                                                 is_cmd?(:put, TT::TTCMDPUTKEEP) }

        def is_cmd?(name, cmdtype)
          if cmdt == cmdtype
            true
          else
            false
          end
        end

        def cmd
          case cmdt 
          when TT::TTCMDMISC
            misc
          when TT::TTCMDPUT
            put
          when TT::TTCMDPUTKEEP
            put
          end
        end

      end
    end
  end
end

