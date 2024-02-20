
Функция 	ВыгрузитьПоступления_income(Объект) Экспорт
	//Отражаем Ответ на выгрузку (Первая точка приема..)
	СтрокаПротокола						= новый Структура ("ДатаНачала, ДатаОкончания,Результат, ПолученныеДанные");
	СтрокаПротокола.ДатаНачала			= ТекущаяДата();
	
	хмл_отправили						= СтоСПОбмен_Запрос.ВыгрузкаПоступлений_income(Объект);//СкомпоноватьДляВыгрузки(Объект);
	стр_Ответа 							= СтоСПОбмен_Выгрузка100сп.Выгрузить(хмл_отправили);
	
	СтрокаПротокола.ДатаОкончания		= ТекущаяДата();
	СтрокаПротокола.ПолученныеДанные	= стр_Ответа.Получили;
	
	Если не стр_Ответа.Свойство("Разбор") Тогда
		СтрокаПротокола.Результат	=	Ложь;
	Иначе	
		СтрокаПротокола.Результат 	= стр_Ответа.Разбор.авторизацияВыполнена;
		Объект.Отправлено        	= СтрокаПротокола.Результат;
	КонецЕсли;
	СтоСПОбмен_Выгрузка100сп.СохранитьПротоколОбмена(СтрокаПротокола,Объект.Ссылка);
	Если не СтрокаПротокола.Результат Тогда Возврат Ложь; Конецесли;
	
	
	Если не стр_Ответа.Разбор.авторизацияВыполнена Тогда Возврат ложь; КонецЕсли;
	
	Статус	= Перечисления.СтатусОтпавкиНаСайт.Отправлен;
	тз		= Неопределено;
	Если стр_Ответа.Разбор.Свойство("incomes",тз) Тогда
		incomes_ОтразитьРезультатВыгрузки(тз, Объект);
	КонецЕсли;	
	// Загружаем состав принятых посылок
	
	ЗагрузитьСоставПосылок(Объект);	
	
	//после того как у посылки появилась основная покупка подгружаем эту покупку и  заполняем из нее организатора в документ
	//Для каждого элем из Объект.Посылки цикл
	//	списокПокупокДляЗагрузки = Новый СписокЗначений;
	//	Если элем.Посылка.Покупка.Догрузить Тогда
	//		списокПокупокДляЗагрузки.Добавить(элем.Посылка.Покупка);
	//	КонецЕсли;
	//	СтоСПОбмен_Покупки.Загрузить(списокПокупокДляЗагрузки);
	//КонецЦикла;
	
	Если (не ЗначениеЗаполнено(Объект.Организатор) или
			 Объект.Организатор.Код = 0	)и
		  Объект.Посылки.Количество()>0 Тогда
		Объект.Организатор	= Объект.Посылки[0].Посылка.Организатор;
	КонецЕсли;	
	Возврат Истина;
КонецФункции


Процедура 	ЗагрузитьСоставПосылок(Объект)
	масс_отправленных	=	Объект.Посылки.НайтиСтроки(новый структура ("Отправлено",Истина));
	список_посылок		=	Новый СписокЗначений;
	Для каждого элем из масс_отправленных цикл
		Если 		элем.Посылка.Догрузить или 
					(не 	элем.Загружено и 
							(элем.ПунктВыдачи.ТранспортнаяКомпания или
							 элем.Посылка.ПунктВыдачи.ТранспортнаяКомпания) ) Тогда
			список_посылок.Добавить(элем.посылка);
		КонецЕсли;
	КонецЦикла;		
	Если список_посылок.Количество()=0 Тогда Возврат КонецЕсли;
	
	стрОтвета = СтоСПОбмен_Посылки.Загрузить_СоставПосылкиПоКодам(список_посылок);
		
	Если не стрОтвета.авторизацияВыполнена Тогда Возврат; КонецЕсли;
	тзПосылок = стрОтвета.Результат;
	Для каждого стр из тзПосылок Цикл
		масс	=	Объект.Посылки.НайтиСтроки(новый Структура("Посылка",стр.Посылка));
		Для каждого элем из масс Цикл
			элем.Загружено	=	стр.Загружена;
			Если не стр.Загружена ТОгда
				элем.СообщениеОшибки="Ошибка загрузки состава посылки: "+стр.Посылка;
			Иначе 	
				элем.СообщениеОшибки="";
			КонецЕсли;	
		КонецЦикла
	КонецЦикла	
КонецПроцедуры


//СтоСПОбмен_Запрос.ВыгрузкаПоступлений_income(Объект); Замена
//Функция		СкомпоноватьДляВыгрузки(Объект) Экспорт
//		
//	ЗаписьXML=новый ЗаписьXML;
//	ЗаписьXML.УстановитьСтроку("UTF-8");
//	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
//	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
//	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
//	ЗаписьXML.ЗаписатьАтрибут("apiVersion","5");
//	///////
//	ЗаписьXML.ЗаписатьНачалоЭлемента("incomes");	
//	хмл_income			= Документы[Объект.метаданные().Имя].ПолучитьТэг_Income_Посылки(Объект.Ссылка);
//	ЗаписьXML.ЗаписатьБезОбработки(хмл_income);

//	ЗаписьXML.ЗаписатьКонецЭлемента();           //incomes
//	//////
//	ЗаписьXML.ЗаписатьКонецЭлемента();           //distributors
//	Возврат ЗаписьXML.Закрыть();
//КонецФункции	
//	
Процедура 	incomes_ОтразитьРезультатВыгрузки(тзПараметр, Объект) 
	Запрос		= новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ТЗ.arrivalNumber 				КАК arrivalNumber,
	|	ТЗ.firstIncomeCode 				КАК firstIncomeCode,
	|	ТЗ.message 						КАК message,
	|	ТЗ.stickerId 					КАК stickerId,
	|	ТЗ.receiverUid 					КАК receiverUid,
	|	ТЗ.packageId 					КАК packageId,
	|	ТЗ.destinationDistributorCode 	КАК destinationDistributorCode,
	|	ТЗ.orderId 						КАК orderId,
	|	ТЗ.groupCode 					КАК groupCode,
	|	ТЗ.orderType 					КАК orderType,
	|	ТЗ.pid 							КАК pid,
	|	ТЗ.secureCode 					КАК secureCode,
	|	ТЗ.result 						КАК result,
	|	ТЗ.date 						КАК date,
	|	ТЗ.packageCreatorUid 			КАК packageCreatorUid,
	|	ТЗ.firstPid 					КАК firstPid,
	|	ТЗ.phone	 					КАК phone,
	|	ТЗ.phoneHash 					КАК phoneHash,
	|	ТЗ.userName 					КАК userName,
	|	ТЗ.freeShipping					КАК freeShipping,
	|	ТЗ.rating						КАК rating,
	|	ТЗ.extraDeliveryCost			КАК extraDeliveryCost,
	|	ТЗ.uid 							КАК uid
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументПосылки.Посылка 		КАК Посылка,
	|	ДокументПосылки.НомерСтроки 	КАК НомерСтроки
	|ПОМЕСТИТЬ Посылки
	|ИЗ
	|	Документ."+Объект.метаданные().Имя+".Посылки 		КАК ДокументПосылки
	|ГДЕ
	|	ДокументПосылки.Ссылка = &Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	ВТ.orderType 					КАК orderType,
	|	ВТ.groupCode 					КАК groupCode,
	|	ВТ.firstIncomeCode 				КАК firstIncomeCode,
	|	ВТ.message 						КАК message,
	|	ВТ.receiverUid 					КАК Uid,
	|	ВТ.packageId 					КАК packageId,
	|	ВТ.secureCode 					КАК secureCode,
	|	ВТ.destinationDistributorCode 	КАК destinationDistributorCode,
	|	ВТ.result 						КАК result,
	|	ВТ.date 						КАК date,
	|	ВТ.packageCreatorUid 			КАК packageCreatorUid,
	|	ВТ.firstPid 					КАК firstPid,
	|	ВТ.freeShipping					КАК freeShipping,
	|	ВТ.phone	 					КАК phone,
	|	ВТ.phoneHash 					КАК phoneHash,
	|	ВТ.rating						КАК rating,	
	|	ВТ.userName 					КАК userName,
	|	ВТ.extraDeliveryCost			КАК extraDeliveryCost,
	|	Посылки.Посылка 				КАК Посылка,
	|	Коробки.Ссылка	 				КАК Коробка,
	|	Участники.Ссылка	 			КАК Участник
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Коробки КАК Коробки
	|		ПО Выразить(ВТ.groupCode Как Строка(25)) = Коробки.Код	
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Участники КАК Участники
	|		ПО 	 	ВТ.receiverUid		= Участники.Код  
	|			и 	Выразить(ВТ.userName  Как Строка(50))	  	= Участники.Наименование 
	|			и 	Выразить(ВТ.phoneHash Как Строка(150))	  	= Участники.ТелефонХэш 
	|		ЛЕВОЕ СОЕДИНЕНИЕ Посылки КАК Посылки
	|		ПО ВТ.packageId = Посылки.Посылка.Код";
	Запрос.Параметры.Вставить("ТЗ",		тзПараметр);
	Запрос.Параметры.Вставить("Ссылка",	Объект.Ссылка);
	Результат	= Запрос.Выполнить();
	ТЗРезультат	= Результат.Выгрузить();
	
	Если ТЗРезультат <> неопределено Тогда  
		Для каждого стр из Объект.Посылки Цикл
			мас_НайденоВОтвете	= ТЗРезультат.НайтиСтроки(Новый Структура("Посылка",стр.Посылка));
			
			Если мас_НайденоВОтвете.Количество()>0 тогда
				стр_ответа	= мас_НайденоВОтвете[0];
				Если 	стр_ответа.result	= "ok" или 
						стр_ответа.result	= "ap" 		Тогда
					стр.Отправлено	= Истина;
					
					//Обновить ник участника
					параметрыУчастника = Новый Структура("Наименование, Телефон1, ТелефонХэш, Рэйтинг",
															стр_ответа.userName, 
															стр_ответа.phone, 
															стр_ответа.phoneHash,
															стр_ответа.rating);
					Участник 	= ?(стр_ответа.Участник = null, СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр_ответа.Uid, параметрыУчастника), стр_ответа.Участник);
					СП_РаботаСоСправочниками.ОбновитьУчастника(Участник, параметрыУчастника);
					Надбавка 	= Число(стр_ответа.extraDeliveryCost);
					БВ		 	= Булево(стр_ответа.freeShipping);
					исходныйПВ 	= СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(	стр_ответа.firstIncomeCode);
					//------------
					параметрыПосылки = Новый структура;
					параметрыПосылки.Вставить("Участник",			Участник); 
					параметрыПосылки.Вставить("НадбавкаЗаОбработку",Надбавка); 
					параметрыПосылки.Вставить("ПерваяТочка",		исходныйПВ);
					параметрыПосылки.Вставить("БесплатнаяВыдача",	БВ);
					параметрыПосылки.Вставить("ПунктВыдачи",		СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(	стр_ответа.destinationDistributorCode));
					параметрыПосылки.Вставить("Покупка",			СП_РаботаСоСправочниками.ПолучитьПокупкуПо_Коду(		стр_ответа.firstPid));
					параметрыПосылки.Вставить("Организатор",		СП_РаботаСоСправочниками.ПолучитьОрганизатораПо_Коду(	стр_ответа.packageCreatorUid));

					параметрыПосылки.Вставить("secureCode",		стр_ответа.secureCode);
					
					СП_РаботаСоСправочниками.ОбновитьПосылку(стр.Посылка,	параметрыПосылки);
					СП_РаботаСоСправочниками.ОбновитьМегаордер(стр.ШК,		параметрыПосылки);
					
					/////РС ДанныеЗаказа
					//	стр.полученУчастник 	= Участник;
					//	стр.поученНадбавка  	= Надбавка;
					//	стр.поученБВ  			= БВ;
					//	стр.полученИсходныйПВ   = исходныйПВ;
					/////РС ДанныеЗаказа Конец
					Если  стр.ПунктВыдачи = Справочники.ТочкиРаздачи.ПунтВыдачиНеУказан Тогда
						стр.ПунктВыдачи = стр.Посылка.ПунктВыдачи;
					КонецЕсли;	

				КонецЕсли;	
				стр.СообщениеОшибки	=	стр_ответа.message;
			Иначе	
				стр.СообщениеОшибки	=	"Не найдено в ответе";
			КонецЕсли;	
		КонецЦикла;
		
		Если ТипЗнч(Объект) = Тип("ДокументОбъект.РазборКоробки") Тогда
			Для каждого стр из Объект.ГруппыНаТранзит Цикл
				мас_НайденоВОтвете = ТЗРезультат.НайтиСтроки(Новый Структура("Коробка, orderType", стр.Коробка, "group"));

				Если мас_НайденоВОтвете.Количество() > 0 тогда
					стр_ответа = мас_НайденоВОтвете[0];
					параметрыКоробки = Новый структура;
					параметрыКоробки.Вставить("ПерваяТочка",		СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(	стр_ответа.firstIncomeCode));
					СП_РаботаСоСправочниками.ОбновитьКоробку(стр.Коробка,	параметрыКоробки);
					СП_РаботаСоСправочниками.ОбновитьМегаордер(стр.ШК,		параметрыКоробки);
					Если стр_ответа.result = "ok" или стр_ответа.result = "ap" Тогда
						стр.Отправлено = Истина;
					КонецЕсли;
					стр.СообщениеОшибки = стр_ответа.message;
				Иначе
					стр.СообщениеОшибки = "Не найдено в ответе";
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
		
		
КонецПроцедуры

	


