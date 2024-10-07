#Область Программныйинтерфейс


Функция ОбменССайтомСтоимость()  экспорт
    Сервер = "russianpostcalc.ru";
    Ресурс = "/api_v1.php";
	Токен	="03f1cb232eb5ae2f011d96f7235e70e8";
	Пароль	="456258";
	
	ПараметрыПостДляХэш= Токен+"|calc|101000|600000|1.34|1000|"+Пароль;
	   ПараметрыПост= 	"?apikey="+Токен+
	                    "&method=calc"+
	                    "&from_index=101000"+
	                    "&to_index=600000"+
	                    "&weight=1.34"+
						"&ob_cennost_rub=1000"+
	    				"&hash="+СтрЗаменить(MD5ХешСтрока(ПараметрыПостДляХэш)," ","");
	
	
	Заголов = Новый Соответствие();
	Заголов.Вставить("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	Попытка
		Соединение = Новый HTTPСоединение(Сервер);//http://api.edostavka.ru/calculator/calculate_price_by_json.php
	Исключение
		Сообщить("Не удалось соединиться с сервером api.edostavka.ru.");
		Возврат Неопределено ;
	КонецПопытки;
	
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс+ПараметрыПост, Заголов);
	
	Попытка
		Ответ = Соединение.Получить(HTTPЗапрос);
		ОтветСтрокой = Сред(ПереобразоватьЮникод(Ответ.ПолучитьТелоКакСтроку()), 6);
		ОтветСтрокой = Сред(ОтветСтрокой, 1, СтрДлина(ОтветСтрокой) - 1);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,);
		Возврат Неопределено;
	КонецПопытки;
	Возврат ОтветСтрокой;
КонецФункции

Функция ОбменССайтомКвитанцияФ7П(Документ)  экспорт
    Сервер = "russianpostcalc.ru";
    Ресурс = "/api_v1.php";
	Токен	="03f1cb232eb5ae2f011d96f7235e70e8";
	Пароль	="456258";
	
	СтрокаЗапроса=ПолучитьЖСОНПБФ(Документ);
	
	ПараметрыПостДляХэш= Токен+"|"+
                        "print_f7p|"+
                        "0|"+
                        "0|["+СтрокаЗапроса+"]|"+Пароль;
	   
	ПараметрыПост= "?apikey="+Токен+
	                    "&method=print_f7p"+
	                    "&print0=0"+
	                    "&printnalogkareq=0"+
	                    "&list=["+СтрокаЗапроса+"]"+
						"&hash="+MD5ХешСтрока(ПараметрыПостДляХэш);

	
	
	Заголов = Новый Соответствие();
	Заголов.Вставить("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");    //"Content-Type", "application/json; charset=UTF-8"
	
	Попытка
		Соединение = Новый HTTPСоединение(Сервер);
	Исключение
		Сообщить("Не удалось соединиться с сервером api.edostavka.ru.");
		Возврат Неопределено ;
	КонецПопытки;
	
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс+СтрЗаменить(ПараметрыПост,"+","%2B"), Заголов);
	
	СсылкаНаКвитанцию="";
	Попытка
		Ответ = Соединение.Получить(HTTPЗапрос);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,);
		Возврат Неопределено;
	КонецПопытки;
	ЧтениеJson=новый ЧтениеJSON;
	ЧтениеJson.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
	Пока ЧтениеJson.Прочитать() Цикл
		Если ЧтениеJson.ТипТекущегоЗначения=ТипЗначенияJSON.ИмяСвойства и ЧтениеJson.ТекущееЗначение="link" Тогда
			ЧтениеJson.Прочитать() ;
			СсылкаНаКвитанцию=ЧтениеJson.ТекущееЗначение;
		КонецЕсли;
	КонецЦикла;	
	Возврат СсылкаНаКвитанцию;
КонецФункции


Функция ОбменССайтомКвитанцияФ112(Документ)  экспорт
    Сервер = "russianpostcalc.ru";
    Ресурс = "/api_v1.php";
	Токен	="03f1cb232eb5ae2f011d96f7235e70e8";
	Пароль	="456258";
	
	СтрокаЗапроса=ПолучитьЖСОНПБФ(Документ,"ф112");
	
	ПараметрыПостДляХэш= Токен+"|"+
                        "print_f112|"+
                        "0|"+
                        "1|["+СтрокаЗапроса+"]|"+Пароль;
	   
	ПараметрыПост= "?apikey="+Токен+
	                    "&method=print_f112"+
	                    "&f113_oborot=0"+
	                    "&nalogka_ur_lico_cb=1"+
	                    "&list=["+СтрокаЗапроса+"]"+
						"&hash="+MD5ХешСтрока(ПараметрыПостДляХэш);

	
	
	Заголов = Новый Соответствие();
	Заголов.Вставить("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");    //"Content-Type", "application/json; charset=UTF-8"
	
	Попытка
		Соединение = Новый HTTPСоединение(Сервер);
	Исключение
		Сообщить("Не удалось соединиться с сервером api.edostavka.ru.");
		Возврат Неопределено ;
	КонецПопытки;
	
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс+СтрЗаменить(ПараметрыПост,"+","%2B"), Заголов);
	
	СсылкаНаКвитанцию="";
	Попытка
		Ответ = Соединение.Получить(HTTPЗапрос);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,);
		Возврат Неопределено;
	КонецПопытки;
	ЧтениеJson=новый ЧтениеJSON;
	ЧтениеJson.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
	Пока ЧтениеJson.Прочитать() Цикл
		Если ЧтениеJson.ТипТекущегоЗначения=ТипЗначенияJSON.ИмяСвойства и ЧтениеJson.ТекущееЗначение="link" Тогда
			ЧтениеJson.Прочитать() ;
			СсылкаНаКвитанцию=ЧтениеJson.ТекущееЗначение;
		КонецЕсли;
	КонецЦикла;	
	Возврат СсылкаНаКвитанцию;
КонецФункции


Функция ОбменССайтомКвитанцияФ103(КоллекцияДокументов)  экспорт
    Сервер = "russianpostcalc.ru";
    Ресурс = "/api_v1.php";
	Токен	="03f1cb232eb5ae2f011d96f7235e70e8";
	Пароль	="456258";
	
	СтрокаЗапроса=ПолучитьЖСОНПБФдляСписка(КоллекцияДокументов,"ф103");
	
	ПараметрыПостДляХэш= Токен+"|"+
                        "print_f103|"+
                        "0|0|"+
                        "0|["+СтрокаЗапроса+"]|"+Пароль;
	   
	ПараметрыПост= "?apikey="+Токен+
	                    "&method=print_f103"+
	                    "&vid_rpo=0"+
	                    "&otpravitel=0"+
						"&mesto_priema=0"+
	                    "&list=["+СтрокаЗапроса+"]"+
						"&hash="+MD5ХешСтрока(ПараметрыПостДляХэш);

	
	
	Заголов = Новый Соответствие();
	Заголов.Вставить("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");    //"Content-Type", "application/json; charset=UTF-8"
	
	Попытка
		Соединение = Новый HTTPСоединение(Сервер);
	Исключение
		Сообщить("Не удалось соединиться с сервером api.edostavka.ru.");
		Возврат Неопределено ;
	КонецПопытки;
	
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс+СтрЗаменить(ПараметрыПост,"+","%2B"), Заголов);
	
	СсылкаНаКвитанцию="";
	Попытка
		Ответ = Соединение.Получить(HTTPЗапрос);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,);
		Возврат Неопределено;
	КонецПопытки;
	ЧтениеJson=новый ЧтениеJSON;
	ЧтениеJson.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
	Пока ЧтениеJson.Прочитать() Цикл
		Если ЧтениеJson.ТипТекущегоЗначения=ТипЗначенияJSON.ИмяСвойства и ЧтениеJson.ТекущееЗначение="link" Тогда
			ЧтениеJson.Прочитать() ;
			СсылкаНаКвитанцию=ЧтениеJson.ТекущееЗначение;
		КонецЕсли;
	КонецЦикла;	
	Возврат СсылкаНаКвитанцию;
КонецФункции




#КонецОбласти


#Область Служебные


Функция ПолучитьЖСОНПБФ(Документ,типКв="ф7п") Экспорт
	Результат="{";
	Тэги=ПолучитьСтруктуруЖСОНДляПБРФ(Документ,типКв);
	Для каждого тэг из тэги Цикл
	 	Результат=Результат+""""+тэг.Ключ+""":"""+ВЮникод(тэг.Значение)+""",";
		//Результат=Результат+""""+тэг.Ключ+""":"""+тэг.Значение+""",";
	КонецЦикла;
	Результат=Лев(Результат,СтрДлина(Результат)-1)+"}";
	
	
	//ЗаписьJSON=новый ЗаписьJSON	;
	//ЗаписьJSON.УстановитьСтроку();
	//ЗаписатьJSON(ЗаписьJSON,ПолучитьСтруктуруЖСОНДляПБРФ());
	//Стр=ЗаписьJSON.Закрыть();
	//Стр=СтрЗаменить(Стр,Символы.ПС," ");
	Возврат Результат;   
КонецФункции

Функция ПолучитьЖСОНПБФдляСписка(КоллекцияДокументов,типКв="ф7п") Экспорт
	Результат="";
	Для каждого Документ из КоллекцияДокументов Цикл
		Результат=Результат+"{";
		Если типКв="ф7п" Тогда
			Тэги=ПолучитьСтруктуруЖСОНДляПБРФ(Документ,типКв);
		Иначе	
			Тэги=ПолучитьСтруктуруЖСОНДляПБРф103(Документ);
		КонецЕсли;
		Для каждого тэг из тэги Цикл
	 		Результат=Результат+""""+тэг.Ключ+""":"""+ВЮникод(тэг.Значение)+""",";
		КонецЦикла;
		Результат=Лев(Результат,СтрДлина(Результат)-1)+"},";
	КонецЦикла;
	Результат=Лев(Результат,СтрДлина(Результат)-1);	
	
	
	//ЗаписьJSON=новый ЗаписьJSON	;
	//ЗаписьJSON.УстановитьСтроку();
	//ЗаписатьJSON(ЗаписьJSON,ПолучитьСтруктуруЖСОНДляПБРФ());
	//Стр=ЗаписьJSON.Закрыть();
	//Стр=СтрЗаменить(Стр,Символы.ПС," ");
	Возврат Результат;   
КонецФункции



Функция MD5ХешСтрока(тСтрока)
   Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
 
   Хеш.Добавить(тСтрока);
 
   Возврат СтрЗаменить(НРег(Хеш.ХешСумма)," ",""); 
КонецФункции


Функция ПолучитьСтруктуруЖСОНДляПБРФ(Документ,типКв)
	//Документ=Документы.ОтправлениеТранзита.СоздатьДокумент();
	СвояТочка=Документ.ТочкаОтправитель;
	стрСвойства=новый структура;
    стрСвойства.Вставить("from_index"		, ?(типКв="ф7п",СокрЛП(СвояТочка.Индекс),СокрЛП(СвояТочка.ИндексНП)));
    стрСвойства.Вставить("from_city"		, СокрЛП(СвояТочка.Город));
    стрСвойства.Вставить("from_state"		, "");
    стрСвойства.Вставить("from_country"		, "Россия");
    стрСвойства.Вставить("from_addr"		, ?(типКв="ф7п",СокрЛП(СвояТочка.АдресПродавцаДляТК),СокрЛП(СвояТочка.АдресНП)));
    стрСвойства.Вставить("from_fio"		    , СокрЛП(СвояТочка.ПродавецДляТК));

    стрСвойства.Вставить("from_inn"			, 	СвояТочка.ИНН);
    стрСвойства.Вставить("from_bik"			, 	СвояТочка.БИК);
    стрСвойства.Вставить("from_bank"		, 	СвояТочка.НаименованиеБанка);
    стрСвойства.Вставить("from_ks"			,	СвояТочка.КорСчет);
    стрСвойства.Вставить("from_rs"			,	СвояТочка.РСчет);
   
    стрСвойства.Вставить("nalogka_ur_lico_cb"	,"0");
    стрСвойства.Вставить("parcel_type"			,"rp");
    стрСвойства.Вставить("order_id"				, "");
    стрСвойства.Вставить("to_fio"				, Документ.ФИО);
    стрСвойства.Вставить("to_country"			, "Россия");
    стрСвойства.Вставить("to_index"				,Документ.Индекс);
    стрСвойства.Вставить("to_state"				, Документ.Регион);
    стрСвойства.Вставить("to_city"				,Документ.Город);
    стрСвойства.Вставить("to_addr"				, Документ.Адрес);
    стрСвойства.Вставить("to_tel"				, СтрЗаменить(Документ.Телефон,"+",""));

		
	//стрСвойства.Вставить("ob_cennost_rub"		,Документ.ТарифТК+Документ.ТарифПВ);
	//стрСвойства.Вставить("nalogka_rub"			,Документ.ТарифТК+Документ.ТарифПВ);	
	стрСвойства.Вставить("ob_cennost_rub"		,Документ.ИтогоСтоимость);
	стрСвойства.Вставить("nalogka_rub"			,Документ.ИтогоСтоимость);	


	Возврат стрСвойства;		
	
КОнецФункции


Функция ПолучитьСтруктуруЖСОНДляПБРф103(Документ)
	//Документ=Документы.ОтправлениеТранзита.СоздатьДокумент();
	СвояТочка=Документ.ТочкаОтправитель;
	стрСвойства=новый структура;
    стрСвойства.Вставить("to_fio"				, Документ.ФИО);
    стрСвойства.Вставить("to_country"			, "Россия");
    стрСвойства.Вставить("to_index"				,Документ.Индекс);
    стрСвойства.Вставить("to_state"				, Документ.Регион);
    стрСвойства.Вставить("to_city"				,Документ.Габарит);
    стрСвойства.Вставить("to_addr"				, Документ.Адрес);

	//стрСвойства.Вставить("ob_cennost_rub"		,Документ.ТарифТК+Документ.ТарифПВ);
	//стрСвойства.Вставить("nalogka_rub"			,Документ.ТарифТК+Документ.ТарифПВ);
	
    стрСвойства.Вставить("ob_cennost_rub"		,Документ.ИтогоСтоимость);
    стрСвойства.Вставить("nalogka_rub"			,Документ.ИтогоСтоимость);	
	

	Возврат стрСвойства;		
	
КОнецФункции



Функция ПереобразоватьЮникод(Строка)

    
    ГотововаяСтрока = "" ;
    
    МасУкр = Новый Массив(66) ;
    
    МасУкр[0]="А";   МасУкр[1]="Б";  МасУкр[2]="В";  МасУкр[3]="Г";  МасУкр[4]="Ґ";  МасУкр[5]="Д";
    МасУкр[6]="Е";   МасУкр[7]="Є";  МасУкр[8]="Ж";  МасУкр[9]="З";  МасУкр[10]="И"; МасУкр[11]="І";
    МасУкр[12]="Ї";  МасУкр[13]="Й"; МасУкр[14]="К"; МасУкр[15]="Л"; МасУкр[16]="М"; МасУкр[17]="Н";
    МасУкр[18]="О";  МасУкр[19]="П"; МасУкр[20]="Р"; МасУкр[21]="С"; МасУкр[22]="Т"; МасУкр[23]="У";
    МасУкр[24]="Ф";  МасУкр[25]="Х"; МасУкр[26]="Ц"; МасУкр[27]="Ч"; МасУкр[28]="Ш"; МасУкр[29]="Щ";
    МасУкр[30]="Ь";  МасУкр[31]="Ю"; МасУкр[32]="Я";  

    МасУкр[33]="а";  МасУкр[34]="б"; МасУкр[35]="в"; МасУкр[36]="г"; МасУкр[37]="ґ"; МасУкр[38]="д";
    МасУкр[39]="е";  МасУкр[40]="є"; МасУкр[41]="ж"; МасУкр[42]="з"; МасУкр[43]="и"; МасУкр[44]="і";
    МасУкр[45]="ї";  МасУкр[46]="й"; МасУкр[47]="к"; МасУкр[48]="л"; МасУкр[49]="м"; МасУкр[50]="н";
    МасУкр[51]="о";  МасУкр[52]="п"; МасУкр[53]="р"; МасУкр[54]="с"; МасУкр[55]="т"; МасУкр[56]="у";
    МасУкр[57]="ф";  МасУкр[58]="х"; МасУкр[59]="ц"; МасУкр[60]="ч"; МасУкр[61]="ш"; МасУкр[62]="щ";
    МасУкр[63]="ь";  МасУкр[31]="ю"; МасУкр[65]="я";  
        
    
    МасКод = Новый Массив(66) ;
    
    МасКод[0]="0410";   МасКод[1]="0411";  МасКод[2]="0412";  МасКод[3]="0413";  МасКод[4]="0490";  МасКод[5]="0414";
    МасКод[6]="0415";   МасКод[7]="0404";  МасКод[8]="0416";  МасКод[9]="0417";  МасКод[10]="0418"; МасКод[11]="0406";
    МасКод[12]="0407";  МасКод[13]="0419"; МасКод[14]="041A"; МасКод[15]="041B"; МасКод[16]="041C"; МасКод[17]="041D";
    МасКод[18]="041E";  МасКод[19]="041F"; МасКод[20]="0420"; МасКод[21]="0421"; МасКод[22]="0422"; МасКод[23]="0423";
    МасКод[24]="0424";  МасКод[25]="0425"; МасКод[26]="0426"; МасКод[27]="0427"; МасКод[28]="0428"; МасКод[29]="0429";
    МасКод[30]="042C";  МасКод[31]="042E"; МасКод[32]="042F";  

    МасКод[33]="0430";  МасКод[34]="0431"; МасКод[35]="0432"; МасКод[36]="0413"; МасКод[37]="0491"; МасКод[38]="0434";
    МасКод[39]="0435";  МасКод[40]="0454"; МасКод[41]="0436"; МасКод[42]="0437"; МасКод[43]="0438"; МасКод[44]="0456";
    МасКод[45]="0457";  МасКод[46]="0439"; МасКод[47]="043A"; МасКод[48]="043B"; МасКод[49]="043C"; МасКод[50]="043D";
    МасКод[51]="043E";  МасКод[52]="043F"; МасКод[53]="0440"; МасКод[54]="0441"; МасКод[55]="0442"; МасКод[56]="0443";
    МасКод[57]="0444";  МасКод[58]="0445"; МасКод[59]="0446"; МасКод[60]="0447"; МасКод[61]="0448"; МасКод[62]="0449";
    МасКод[63]="044C";  МасКод[31]="044E"; МасКод[65]="044F";  
    
    
    тмпСтрока = "" ;
    Для Счетчик = 1 По СтрДлина(Строка) Цикл      
        Если Лев(Строка, 1) = "\" Тогда
            Если Лев(Строка, 2) = "\u" Тогда
                
                тмпСтрока = Прав(Лев(Строка, 6),4) ;
                Если МасКод.Найти(тмпСтрока) = Неопределено Тогда
                    СтрокаЗамены = Прав(тмпСтрока, 1) ;
                    тмпСтрока = СтрЗаменить(тмпСтрока,СтрокаЗамены,ТРег(СтрокаЗамены)); 
					Если МасКод.Найти(тмпСтрока) = Неопределено Тогда
						// не найден и не найден. Хрен с ним. Всё-равно это в русском языке. Пользователь и так поймёт.
						// ничего пользователю говорить не будем.  
						//Сообщить("Код символа не найден: " + тмпСтрока);
                    Иначе                      
                        ГотововаяСтрока = ГотововаяСтрока + МасУкр[МасКод.Найти(тмпСтрока)] ;                                   
                    КонецЕсли;
                Иначе
                    ГотововаяСтрока = ГотововаяСтрока + МасУкр[МасКод.Найти(тмпСтрока)] ;               
                КонецЕсли;
                
                Строка = Прав(Строка, (СтрДлина(Строка)-6)) ; 
			ИначеЕсли Лев(Строка, 2) = "\/" Тогда
	            ГотововаяСтрока = ГотововаяСтрока +"\";
				Строка = Прав(Строка, (СтрДлина(Строка)-2))
            Иначе  
                Строка = Прав(Строка, (СтрДлина(Строка)-2)) ;
            КонецЕсли;
        Иначе
            ГотововаяСтрока = ГотововаяСтрока + Лев(Строка, 1) ;
            Строка = Прав(Строка, (СтрДлина(Строка)-1)) ;     
        КонецЕсли;         
    КонецЦикла;   

    Возврат СтрЗаменить(ГотововаяСтрока,"\/","\") ;
        
КонецФункции


Функция ВЮникод(Строка)
    
    МасКир = Новый Массив(66);
    МасКод = Новый Массив(66);
	
	МасКир[0]="А";    МасКод[0]="0410";
	МасКир[1]="а";    МасКод[1]="0430";
	МасКир[2]="Б";    МасКод[2]="0411";
	МасКир[3]="б";    МасКод[3]="0431";
	МасКир[4]="В";    МасКод[4]="0412";
	МасКир[5]="в";    МасКод[5]="0432";
	МасКир[6]="Г";    МасКод[6]="0413";
	МасКир[7]="г";    МасКод[7]="0433";
	МасКир[8]="Д";    МасКод[8]="0414";
	МасКир[9]="д";    МасКод[9]="0434";
	МасКир[10]="Е";    МасКод[10]="0415";
	МасКир[11]="е";    МасКод[11]="0435";
	МасКир[12]="Ё";    МасКод[12]="0401";
	МасКир[13]="ё";    МасКод[13]="0451";
	МасКир[14]="Ж";    МасКод[14]="0416";
	МасКир[15]="ж";    МасКод[15]="0436";
	МасКир[16]="З";    МасКод[16]="0417";
	МасКир[17]="з";    МасКод[17]="0437";
	МасКир[18]="И";    МасКод[18]="0418";
	МасКир[19]="и";    МасКод[19]="0438";
	МасКир[20]="Й";    МасКод[20]="0419";
	МасКир[21]="й";    МасКод[21]="0439";
	МасКир[22]="К";    МасКод[22]="041a";
	МасКир[23]="к";    МасКод[23]="043a";
	МасКир[24]="Л";    МасКод[24]="041b";
	МасКир[25]="л";    МасКод[25]="043b";
	МасКир[26]="М";    МасКод[26]="041c";
	МасКир[27]="м";    МасКод[27]="043c";
	МасКир[28]="Н";    МасКод[28]="041d";
	МасКир[29]="н";    МасКод[29]="043d";
	МасКир[30]="О";    МасКод[30]="041e";
	МасКир[31]="о";    МасКод[31]="043e";
	МасКир[32]="П";    МасКод[32]="041f";
	МасКир[33]="п";    МасКод[33]="043f";
	МасКир[34]="Р";    МасКод[34]="0420";
	МасКир[35]="р";    МасКод[35]="0440";
	МасКир[36]="С";    МасКод[36]="0421";
	МасКир[37]="с";    МасКод[37]="0441";
	МасКир[38]="Т";    МасКод[38]="0422";
	МасКир[39]="т";    МасКод[39]="0442";
	МасКир[40]="У";    МасКод[40]="0423";
	МасКир[41]="у";    МасКод[41]="0443";
	МасКир[42]="Ф";    МасКод[42]="0424";
	МасКир[43]="ф";    МасКод[43]="0444";
	МасКир[44]="Х";    МасКод[44]="0425";
	МасКир[45]="х";    МасКод[45]="0445";
	МасКир[46]="Ц";    МасКод[46]="0426";
	МасКир[47]="ц";    МасКод[47]="0446";
	МасКир[48]="Ч";    МасКод[48]="0427";
	МасКир[49]="ч";    МасКод[49]="0447";
	МасКир[50]="Ш";    МасКод[50]="0428";
	МасКир[51]="ш";    МасКод[51]="0448";
	МасКир[52]="Щ";    МасКод[52]="0429";
	МасКир[53]="щ";    МасКод[53]="0449";
	МасКир[54]="Ъ";    МасКод[54]="042a";
	МасКир[55]="ъ";    МасКод[55]="044a";
	МасКир[56]="Ы";    МасКод[56]="042b";
	МасКир[57]="ы";    МасКод[57]="044b";
	МасКир[58]="Ь";    МасКод[58]="042c";
	МасКир[59]="ь";    МасКод[59]="044c";
	МасКир[60]="Э";    МасКод[60]="042d";
	МасКир[61]="э";    МасКод[61]="044d";
	МасКир[62]="Ю";    МасКод[62]="042e";
	МасКир[63]="ю";    МасКод[63]="044e";
	МасКир[64]="Я";    МасКод[64]="042f";
	МасКир[65]="я";    МасКод[65]="044f";
    ParsedString = Строка;
    Flag = 1;
	Результат="";
	
	
	Для стр=1 по СтрДлина(Строка) цикл
     СледующийСимвол = Сред(Строка, стр, 1);
	 Index = МасКир.Найти(СледующийСимвол);
	 
	 если СледующийСимвол="""" Тогда
		 Результат=Результат+"\""";
		 
	 ИначеЕсли Index=Неопределено Тогда
		 Результат=Результат+СледующийСимвол;
	 Иначе	
		 Результат=Результат+"\u"+МасКод[Index];
	 КонецЕсли;
	 
 КонецЦикла;
 
	
    
	//Пока (Flag = 1) Цикл
	//    
	//PositionOfUnicodeStart = Найти(ParsedString, "\u");
	//    
	//
	//    Если PositionOfUnicodeStart > 0 тогда
	//    UnicodeSymbol = Сред(ParsedString, PositionOfUnicodeStart +2, 4);    
	//    
	//    FullUnicodeSymbol = "\u" + UnicodeSymbol;
	//    
	//    Index = МасКод.Найти(UnicodeSymbol);
	//        Если Index = Неопределено тогда
	//        ParsedString = СтрЗаменить(ParsedString, FullUnicodeSymbol, "?UNICODE?");
	//        Сообщить("Найден неизвестный символ - " + FullUnicodeSymbol); 
	//        Иначе
	//        ParsedString = СтрЗаменить(ParsedString, FullUnicodeSymbol, МасКир[Index]);
	//        КонецЕсли;
	//            
	//    Иначе 
	//    Flag = 0;
	//    
	//    КонецЕсли;
	//                
	//КонецЦикла;
	//
    Возврат Результат;    
КонецФункции
#КонецОбласти
