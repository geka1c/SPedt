
Функция 	ЗагрузитьПраздничныеДни(Объект, НачалоГода) Экспорт
	//Отражаем Ответ на выгрузку (Первая точка приема..)
	
	ДатаНачала							= НачалоГода(НачалоГода);
	СтрокаПротокола						= СтоСПОбмен_Выгрузка100сп.СтруктураПротокола();
	СтрокаПротокола.ДатаНачала			= ТекущаяДата();
	
	хмл_отправили						= СтоСПОбмен_Запрос.СписокПраздничныхДней_distributorHolidays(ДатаНачала);
	стр_Ответа 							= СтоСПОбмен_Выгрузка100сп.Загрузить(хмл_отправили);
	СтрокаПротокола.Описание			= "Загрузка Праздников";
	
	СтрокаПротокола.Отправили			= хмл_отправили;
	
	СтрокаПротокола.ДатаОкончания		= ТекущаяДата();
	СтрокаПротокола.ПолученныеДанные	= стр_Ответа.Получили;
	
	Если не стр_Ответа.Свойство("Разбор") Тогда
		СтрокаПротокола.Результат	=	Ложь;
	Иначе	
		СтрокаПротокола.Результат 	= стр_Ответа.Разбор.авторизацияВыполнена;
	КонецЕсли;
	СтоСПОбмен_Выгрузка100сп.СохранитьПротоколОбмена(СтрокаПротокола,Объект.Ссылка);
	Если не СтрокаПротокола.Результат Тогда Возврат Ложь; Конецесли;
	
	
	Если не стр_Ответа.Разбор.авторизацияВыполнена Тогда Возврат ложь; КонецЕсли;
	
	Статус	= Перечисления.СтатусОтпавкиНаСайт.Отправлен;
	тз		= Неопределено;
	Если стр_Ответа.Разбор.Свойство("distributorHoliday",тз) Тогда
		ОтразитьПраздники(тз, Объект);
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции

Процедура 	ОтразитьПраздники(тз, Объект) 
	Для каждого элем из тз Цикл       
		ДатаПраздника = СтоСПОбмен_Общий.ДатаИзСтроки(элем.date);
		
		Найдено = Объект.Праздники.НайтиСтроки(Новый Структура("Дата",ДатаПраздника));
		Если Найдено.Количество()>0 Тогда
			строкаПраздника = Найдено[0];
		Иначе	
			строкаПраздника	= Объект.Праздники.Добавить();	
			строкаПраздника.Дата		  	= ДатаПраздника ;
		КонецЕсли;	
		
		строкаПраздника.ВремяНачала	  	= СтоСПОбмен_Общий.ДатаИзСтроки("00010101"+элем.from);
		строкаПраздника.ВремяОкончания 	= СтоСПОбмен_Общий.ДатаИзСтроки("00010101"+тз[0].to);
		строкаПраздника.Комментарий	  	= элем.comment;
		строкаПраздника.id			  	= элем.id;
	КонецЦикла;
КонецПроцедуры

	




Функция 	ЗагрузитьРежимРаботы(Объект) Экспорт
	//Отражаем Ответ на выгрузку (Первая точка приема..)
	СтрокаПротокола						= СтоСПОбмен_Выгрузка100сп.СтруктураПротокола();
	СтрокаПротокола.ДатаНачала			= ТекущаяДата();
	
	хмл_отправили						= СтоСПОбмен_Запрос.РежимРаботы_distributorTimetable();
	стр_Ответа 							= СтоСПОбмен_Выгрузка100сп.Загрузить(хмл_отправили);
	СтрокаПротокола.Описание			= "Загрузка режима работы";
	
	СтрокаПротокола.Отправили			= хмл_отправили;
	СтрокаПротокола.ДатаОкончания		= ТекущаяДата();
	СтрокаПротокола.ПолученныеДанные	= стр_Ответа.Получили;
	
	Если не стр_Ответа.Свойство("Разбор") Тогда
		СтрокаПротокола.Результат	=	Ложь;
	Иначе	
		СтрокаПротокола.Результат 	= стр_Ответа.Разбор.авторизацияВыполнена;
	КонецЕсли;
	СтоСПОбмен_Выгрузка100сп.СохранитьПротоколОбмена(СтрокаПротокола,Объект.Ссылка);
	Если не СтрокаПротокола.Результат Тогда Возврат Ложь; Конецесли;
	
	
	Если не стр_Ответа.Разбор.авторизацияВыполнена Тогда Возврат ложь; КонецЕсли;
	
	Статус	= Перечисления.СтатусОтпавкиНаСайт.Отправлен;
	тз		= Неопределено;
	Если стр_Ответа.Разбор.Свойство("distributorTimetable",тз) Тогда
		ОтразитьРежимРаботы(тз, Объект);
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции


Процедура ОтразитьРежимРаботы(тз, Объект)
	Объект.РежимРаботы.Очистить();
	Для каждого элем из тз Цикл
		Для каждого Колонка из тз.Колонки Цикл
			Если Колонка.Имя = "distributorCode" Тогда Продолжить; КонецЕсли;
			новаяСтрока 				= Объект.РежимРаботы.Добавить();
			новаяСтрока.ДеньНедели  	= Колонка.Имя;
			новаяСтрока.ВремяРаботы  	= элем[Колонка.Имя];
			новаяСтрока.РабочийДень  	= (элем[Колонка.Имя]<>"");
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры	


Функция 	ДобавитьНеРабочиеДни(НеРабочиеДни,Объект) Экспорт
	//Отражаем Ответ на выгрузку (Первая точка приема..)
	СтрокаПротокола						= новый Структура ("ДатаНачала, ДатаОкончания,Результат, ПолученныеДанные");
	СтрокаПротокола.ДатаНачала			= ТекущаяДата();
	
	хмл_отправили						= СтоСПОбмен_Запрос.ДобавитьНеРабочиеДни_distributorHolidaysAdd(НеРабочиеДни);
	стр_Ответа 							= СтоСПОбмен_Выгрузка100сп.Выгрузить(хмл_отправили);
	
	СтрокаПротокола.ДатаОкончания		= ТекущаяДата();
	СтрокаПротокола.ПолученныеДанные	= стр_Ответа.Получили;
	
	Если не стр_Ответа.Свойство("Разбор") Тогда
		СтрокаПротокола.Результат	=	Ложь;
	Иначе	
		СтрокаПротокола.Результат 	= стр_Ответа.Разбор.авторизацияВыполнена;
	КонецЕсли;
	СтоСПОбмен_Выгрузка100сп.СохранитьПротоколОбмена(СтрокаПротокола,Объект.Ссылка);
	Если не СтрокаПротокола.Результат Тогда Возврат Ложь; Конецесли;
	
	
	Если не стр_Ответа.Разбор.авторизацияВыполнена Тогда Возврат ложь; КонецЕсли;
	
	Статус	= Перечисления.СтатусОтпавкиНаСайт.Отправлен;
	тз		= Неопределено;
	Если стр_Ответа.Разбор.Свойство("distributorHolidaysAdd",тз) Тогда
		ОтразитьНеРабочиеДни(тз, Объект);
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции

Процедура 	ОтразитьНеРабочиеДни(тз, Объект) 
	Объект.ДобавитьНеРабочиеДни.Очистить();
	Для каждого элем из тз Цикл
		новаяСтрока 				= Объект.ДобавитьНеРабочиеДни.Добавить();
		новаяСтрока.Дата		  	= СтоСПОбмен_Общий.ДатаИзСтроки(элем.date);
		новаяСтрока.ВремяНачала	  	= СтоСПОбмен_Общий.ДатаИзСтроки("00010101"+элем.from);
		новаяСтрока.ВремяОкончания 	= СтоСПОбмен_Общий.ДатаИзСтроки("00010101"+тз[0].to);
		новаяСтрока.Комментарий	  	= элем.comment;
		новаяСтрока.id			  	= элем.id;
	КонецЦикла;
КонецПроцедуры

	
	
	