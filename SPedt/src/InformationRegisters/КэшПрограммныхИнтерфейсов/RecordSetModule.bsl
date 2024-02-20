#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОписаниеПеременных

Перем ТребуетсяКонтроль;
Перем ДанныеДляЗаписи;
Перем ПодготовленыДанные;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если ПодготовленыДанные Тогда
		Загрузить(ДанныеДляЗаписи);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
	
	Если ТребуетсяКонтроль Тогда
		
		Для Каждого Запись Из ЭтотОбъект Цикл
			
			КонтрольныеСтроки = ДанныеДляЗаписи.НайтиСтроки(
				Новый Структура("Идентификатор, ТипДанных", Запись.Идентификатор, Запись.ТипДанных));
			
			Если КонтрольныеСтроки.Количество() <> 1 Тогда
				ОшибкаКонтроля();
			Иначе
				
				КонтрольнаяСтрока = КонтрольныеСтроки.Получить(0);
				
				ТекущиеДанные = ОбщегоНазначения.ЗначениеВСтрокуXML(Запись.Данные.Получить());
				КонтрольныеДанные = ОбщегоНазначения.ЗначениеВСтрокуXML(КонтрольнаяСтрока.Данные.Получить());
				
				Если ТекущиеДанные <> КонтрольныеДанные Тогда
					ОшибкаКонтроля();
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьДанныеДляЗаписи() Экспорт
	
	ПараметрыПолучения = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ПараметрыПолучения", ПараметрыПолучения) Тогда
		ВызватьИсключение НСтр("ru = 'Не определены параметры получения данных'");
	КонецЕсли;
	
	ДанныеДляЗаписи = Выгрузить();
	
	Для Каждого Строка Из ДанныеДляЗаписи Цикл
		
		Данные = РегистрыСведений.КэшПрограммныхИнтерфейсов.ПодготовитьДанныеКэшаВерсий(Строка.ТипДанных, ПараметрыПолучения);
		Строка.Данные = Новый ХранилищеЗначения(Данные);
		
	КонецЦикла;
	
	ПодготовленыДанные = Истина;
	
КонецПроцедуры

Процедура ОшибкаКонтроля()
	
	ВызватьИсключение НСтр("ru = 'Недопустимое изменение ресурса Данные записи регистра сведений КэшПрограммныхИнтерфейсов
                            |внутри транзакции записи из сеанса с включенным разделением.'");
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ДанныеДляЗаписи = Новый ТаблицаЗначений();
ТребуетсяКонтроль = ОбщегоНазначения.РазделениеВключено() И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
ПодготовленыДанные = Ложь;

#КонецОбласти

#КонецЕсли
