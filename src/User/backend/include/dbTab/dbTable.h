#ifndef DBTABLE_H
#define DBTABLE_H

#include <QString>
#include <QMap>
#include <QVariant>

namespace dbTable
{

    namespace service{        
        enum{
            query   = 0x01,            
            setting = 0x02,            
            storage = 0x04,
            noticeUi= 0x08,
            ack     = 0x10,
        };        
    }
    
    struct DBItem
    {
        QVariant  value = 0.0;
        QMap<QString, QVariant> extraFields;

        QVariantMap toMap() const
        {
            QVariantMap map{{"value", value}};

            for (auto it = extraFields.constBegin(); it != extraFields.constEnd(); ++it)
            {
                map[it.key()] = it.value();
            }
            return map;
        }
    };


    union DataId
    {
        unsigned short value;        
        struct
        {
            unsigned char number;
            unsigned char category;
        }field;
    };

    // struct Item
    // {
    //     DataId dataId;
    //     unsigned short logID;
    //     void* data;
    // };
    
    struct Detail
    {
        unsigned char group;
        unsigned short dataSize;
        long long  itemNum;
        unsigned char service;
    };

    /**
     * {classType}
     * @brief   
     */
    class Tab 
    { 
    protected:
        //static bool isUploading();
          //________________________________________________________  
         //construct,destruct                                      /
        //________________________________________________________/        
    public:
        Tab(const Detail& detail)
        :detail(detail)
        {}

        ~Tab() {}
        
              
        //virtual void response(utils::Packet& packet,const framework::table::DataId& dataId);        
                

          //________________________________________________________  
         //implement                                               /
        //________________________________________________________/        
    public: 
        // virtual void loadConfig_default() {}
        // virtual void checkLoadConfig_default() {}
        // virtual void loadConfig_storage() {}
        
    protected:
        //virtual const void* getList() = 0;
        //virtual const Item* findItem(void* dataAddress);
        
        //virtual const Item* operator[](unsigned int index) = 0;          
        //virtual unsigned char set(unsigned char*  newData,const Item* item) {}
        //virtual const void* findDefault(unsigned int index);
        //virtual void responseAllItems(app::uiComm::PacketSlip& packet);
        //virtual void response(app::uiComm::PacketSlip& packet,const app::dbTab::DataId& dataId);
        //virtual void sendItem(app::uiComm::PacketSlip& packet,const app::dbTab::Item& item);
        //virtual void sendItemData(app::uiComm::PacketSlip& packet,const app::dbTab::Item& item);
        //virtual void clone(void* newData,void* );
          //________________________________________________________  
         //my method                                               /
        //________________________________________________________/        
    public:
        //void loadConfig();
        
        unsigned char getGroup();
        unsigned int getItemNum();
        unsigned int getDataSize();
        
        virtual QVariant getItemValue(const DataId& dataId) = 0;
        virtual void setItemValue(const DataId& dataId, const QVariant wrData) = 0;       
        //unsigned int findIndexByDataId(const DataId& dataId);

        //virtual void handlerQuery(utils::Queue<unsigned char>& rxMsg
        //                   ,app::uiComm::PacketSlip& packet);
        
    protected:
        //void response(app::uiComm::PacketSlip& packet,unsigned int index);
        //void responseData(app::uiComm::PacketSlip& packet,unsigned int index);
          //________________________________________________________  
         //my data                                                 /
        //________________________________________________________/        
    protected:
        const Detail& detail;
    
    };
    
      //________________________________________________________  
     //inline                                                  /
    //________________________________________________________/
    inline unsigned char Tab::getGroup()    {return (*this).detail.group;}
    inline unsigned int Tab::getItemNum()   {return (*this).detail.itemNum;}
    inline unsigned int Tab::getDataSize()  {return (*this).detail.dataSize;}
    //inline const void* Tab::findDefault(unsigned int index) {return NULL;}
    //inline bool Tab::isUploading() {return false;}
}

#endif
