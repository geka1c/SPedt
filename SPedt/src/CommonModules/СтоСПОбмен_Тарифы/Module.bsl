
Функция 	ВыгрузитьТарифыПоНаправлениямНаСервер(Объект) Экспорт
	//Отражаем Ответ на выгрузку (Первая точка приема..)
	
	
	Для каждого элем из Объект.Тарифы Цикл
		Позиция = СтрНайти(элем.Габарит.Код,"-");
		Если Позиция = 0   Тогда
			КодОтправили = Число(Элем.Габарит.Код);
		Иначе	
			КодОтправили = Число(Прав(Элем.Габарит.Код,СтрДлина(Элем.Габарит.Код)-Позиция));
		КонецЕсли;
		элем.КодОтправлен = КодОтправили;
		
	КонецЦикла;
	
	

	СтрокаПротокола						= СтоСПОбмен_Выгрузка100сп.СтруктураПротокола();
	СтрокаПротокола.ДатаНачала			= ТекущаяДата();
	
	хмл_отправили						= СтоСПОбмен_Запрос. ВыгрузитьТарифыПоНаправлениямсей_tariffsByDestination_ПоОбъекту(Объект);
	стр_Ответа 							= СтоСПОбмен_Выгрузка100сп.Выгрузить(хмл_отправили);
	СтрокаПротокола.Описание			= "Выгрузка тарифов";
	
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
	Если стр_Ответа.Разбор.Свойство("tariffsByDestination",тз) Тогда
		ОтразитьТариыфыПоНаправлениям(тз, Объект);
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции

Функция 	ВыгрузитьТарифыНаСервер(Объект) Экспорт
	//Отражаем Ответ на выгрузку (Первая точка приема..)
	

	СтрокаПротокола						= СтоСПОбмен_Выгрузка100сп.СтруктураПротокола();
	СтрокаПротокола.ДатаНачала			= ТекущаяДата();
	
	хмл_отправили						= СтоСПОбмен_Запрос.ВыгрузитьТарифы_tariffs_ПоОбъекту(Объект);
	стр_Ответа 							= СтоСПОбмен_Выгрузка100сп.Выгрузить(хмл_отправили);
	СтрокаПротокола.Описание			= "Выгрузка тарифов";
	
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
	Если стр_Ответа.Разбор.Свойство("tariffs",тз) Тогда
		Для каждого элем из стр_Ответа.Разбор.tariffs Цикл
			массСтрок = объект.Тарифы.НайтиСтроки(Новый Структура("КодОтправлен",число(элем.id)));
			Если массСтрок.Количество() >0 Тогда
				получили =  массСтрок[0];
				
				Если элем.result="ok" Тогда
					получили.Отправлен = Истина;
					получили.КодПолучен = элем.originalId
				Иначе	
					получили.СообщениеОшибки = элем.message;
				КонецЕсли	
			Иначе	
				ф=1;
				//элем.СообщениеОшибки = "не найдено в ответе";
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции

Процедура 	ОтразитьТариыфыПоНаправлениям(тз, Объект) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	вт.originalId КАК originalId,
		|	вт.id КАК id,
		|	вт.from КАК fromCity,
		|	вт.to КАК toCity,
		|	вт.result КАК result,
		|	вт.message КАК message
		|ПОМЕСТИТЬ вт
		|ИЗ
		|	&вт КАК вт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГородаСП.Ссылка КАК ГородОтправитель,
		|	ГородаСП1.Ссылка КАК ГородПолучатель,
		|	вт.result КАК result,
		|	вт.message КАК message,
		|	вт.originalId КАК originalId,
		|	вт.id КАК id
		|ИЗ
		|	вт КАК вт
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГородаСП КАК ГородаСП
		|		ПО ((ВЫРАЗИТЬ(вт.fromCity КАК СТРОКА(9))) = ГородаСП.Код)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГородаСП КАК ГородаСП1
		|		ПО ((ВЫРАЗИТЬ(вт.toCity КАК СТРОКА(9))) = ГородаСП1.Код)";
	
	Запрос.Параметры.Вставить("вт",тз);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		массСтрок =Объект.Тарифы.НайтиСтроки(Новый Структура("Откуда, Куда, КодОтправлен", Выборка.ГородОтправитель, Выборка.ГородПолучатель, Число(Выборка.id)));
		
		Если массСтрок.Количество() >0 Тогда
			получили =  массСтрок[0];
			
			Если Выборка.result="ok" Тогда
				получили.Отправлен = Истина;
				получили.КодПолучен = Выборка.originalId
			Иначе	
				получили.СообщениеОшибки = Выборка.message;
			КонецЕсли	
		Иначе	
			ф=1;
			//элем.СообщениеОшибки = "не найдено в ответе";
		КонецЕсли;	
		
	КонецЦикла;
	

	
	
	
	
КонецПроцедуры

	

Процедура ПеревестиТарифыВРегистр() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТарифыСрезПоследних.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТарифыПоНаправлениямСрезПоследних.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.ТарифыПоНаправлениям.СрезПоследних КАК ТарифыПоНаправлениямСрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТарифыПоНаправлениямСрезПоследних.Период УБЫВ";
		
	МассивРезультат = Запрос.ВыполнитьПакет();		
	
	Результат = МассивРезультат[0];
	Если Результат.Пустой() Тогда
		УстановкаТарифов 			= Документы.УстановкаТарифов.СоздатьДокумент();
		УстановкаТарифов.Дата 		= ТекущаяДата();
		УстановкаТарифов.ЗаполнитьПоСправочнику();
		УстановкаТарифов.Записать(РежимЗаписиДокумента.Запись);
		СтоСПОбмен_Тарифы.ВыгрузитьТарифыНаСервер(УстановкаТарифов);
		УстановкаТарифов.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	
	ВыборкаДетальныеЗаписи = МассивРезультат[1].Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ТарифыПоНаправлениям = ВыборкаДетальныеЗаписи.Регистратор.ПолучитьОбъект();
		СтоСПОбмен_Тарифы.ВыгрузитьТарифыПоНаправлениямНаСервер(ТарифыПоНаправлениям);
		ТарифыПоНаправлениям.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	

	
КонецПроцедуры	
	

Процедура ПеревестиТарифыВРегистр2() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТарифыСрезПоследних.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ 
		|	ТарифыПоНаправлениямСрезПоследних.Период КАК Период,
		|	ТарифыПоНаправлениямСрезПоследних.Регистратор КАК Регистратор,
		|	ТарифыПоНаправлениямСрезПоследних.НомерСтроки КАК НомерСтроки,
		|	ТарифыПоНаправлениямСрезПоследних.Активность КАК Активность,
		|	ТарифыПоНаправлениямСрезПоследних.Габарит КАК Габарит,
		|	ТарифыПоНаправлениямСрезПоследних.Откуда КАК Откуда,
		|	ТарифыПоНаправлениямСрезПоследних.Куда КАК Куда,
		|	ТарифыПоНаправлениямСрезПоследних.Стоимость КАК Стоимость,
		|	ТарифыПоНаправлениямСрезПоследних.Отменен КАК Отменен
		|ИЗ
		|	РегистрСведений.ТарифыПоНаправлениям.СрезПоследних КАК ТарифыПоНаправлениямСрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТарифыПоНаправлениямСрезПоследних.Период УБЫВ";
		
	МассивРезультат = Запрос.ВыполнитьПакет();		
	
	Результат = МассивРезультат[0];
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.выбрать();
		Выборка.Следующий();
		Регистратор=Выборка.Регистратор;
		об = Регистратор.ПолучитьОбъект();
		Об.ПеренумероватьГабариты();
		СтоСПОбмен_Тарифы.ВыгрузитьТарифыНаСервер(Об);
		Об.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	
	РезультатПоНаправлениям = МассивРезультат[1];
	
	Если не РезультатПоНаправлениям.пустой() Тогда
		
		ТарифыПоНаправлениям = Документы.УстановкаТарифовПоНаравлениям.СоздатьДокумент();
		ТарифыПоНаправлениям.Дата = ТекущаяДата();
		ТарифыПоНаправлениям.Тарифы.Загрузить(РезультатПоНаправлениям.Выгрузить());
		ТарифыПоНаправлениям.Записать(РежимЗаписиДокумента.Проведение);
		СтоСПОбмен_Тарифы.ВыгрузитьТарифыПоНаправлениямНаСервер(ТарифыПоНаправлениям);
		ТарифыПоНаправлениям.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	

	
КонецПроцедуры	


Процедура НомераТарифовИзРегистра() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТарифыСрезПоследних.Габарит КАК Габарит,
		|	ТарифыСрезПоследних.кодТарифа КАК кодТарифа
		|ИЗ
		|	РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если  Выборка.КодТарифа = "" или Выборка.Габарит.Код = Выборка.КодТарифа Тогда Продолжить; КонецЕсли;
		об 		= Выборка.Габарит.ПолучитьОбъект();
		об.ПометкаУдаления = Ложь;
		об.Код 	= Выборка.КодТарифа;
		Попытка
		    об.Записать()
		Исключение
		
		КонецПопытки;
	КонецЦикла;
	


	
	
КонецПроцедуры



Процедура ВыгрузитьТарифыРегламентноеЗадание() Экспорт
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ ПЕРВЫЕ 1
	//	|	ТарифыСрезПоследних.Регистратор КАК Регистратор
	//	|ИЗ
	//	|	РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	ТарифыСрезПоследних.Период УБЫВ
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ  ПЕРВЫЕ 1
	//	|	ТарифыПоНаправлениямСрезПоследних.Регистратор КАК Регистратор
	//	|ИЗ
	//	|	РегистрСведений.ТарифыПоНаправлениям.СрезПоследних КАК ТарифыПоНаправлениямСрезПоследних
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	ТарифыПоНаправлениямСрезПоследних.Период УБЫВ";
	//	
	//МассивРезультат = Запрос.ВыполнитьПакет();		
	//
	//Результат = МассивРезультат[0];
	//Если Не Результат.Пустой() Тогда
	//	Выборка = Результат.выбрать();
	//	Выборка.Следующий();
	//	Регистратор=Выборка.Регистратор;
	//	об = Регистратор.ПолучитьОбъект();
	//	СтоСПОбмен_Тарифы.ВыгрузитьТарифыНаСервер(Об);
	//	Об.Записать(РежимЗаписиДокумента.Проведение);
	//КонецЕсли;
	//
	//
	//РезультатПоНаправлениям = МассивРезультат[1];
	//
	//Если не РезультатПоНаправлениям.пустой() Тогда
	//	
	//	Выборка = РезультатПоНаправлениям.Выбрать();
	//	Выборка.Следующий();
	//	Регистратор=Выборка.Регистратор;
	//	ТарифыПоНаправлениям = Регистратор.ПолучитьОбъект();
	//	СтоСПОбмен_Тарифы.ВыгрузитьТарифыПоНаправлениямНаСервер(ТарифыПоНаправлениям);
	//	ТарифыПоНаправлениям.Записать(РежимЗаписиДокумента.Проведение);
	//КонецЕсли;
	

	
КонецПроцедуры	

