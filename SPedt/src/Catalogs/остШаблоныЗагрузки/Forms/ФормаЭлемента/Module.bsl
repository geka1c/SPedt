
&НаКлиенте
Процедура СКД(Команда)
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		Конструктор = Новый КонструкторСхемыКомпоновкиДанных(ПолучитьСхемуКомпоновкиДанныхКлиент());
		Конструктор.Редактировать(ЭтаФорма);
	#Иначе
		ПоказатьПредупреждение(,НСтр("ru='Конструктор схемы компоновки данных можно открыть только в толстом клиенте. В тонком клиенте и веб клиенте редактирование схемы компоновки данных возможно только в тексте схемы компоновки данных.'"));
	#КонецЕсли

	
	//Схема = ПолучитьСхему();
	//Конструктор = Новый КонструкторСхемыКомпоновкиДанных(Схема);
	//Конструктор.Редактировать(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСхемуКомпоновкиДанныхКлиент()
	
#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	Возврат ПолучитьСхемуКомпоновкиДанных();
#КонецЕсли
	
КонецФункции



Функция ПолучитьСхемуКомпоновкиДанных()
	
#Если ТолстыйКлиентУправляемоеПриложение Или ТолстыйКлиентОбычноеПриложение Или Сервер Тогда
	
	обСправочника=ДанныеФормыВЗначение(Объект,Тип("СправочникОбъект.остШаблоныЗагрузки"));
	
	ТекстСхемы = обСправочника.СКД;
	Если ТекстСхемы <> "" Тогда 
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ТекстСхемы);
		Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML, Тип("СхемаКомпоновкиДанных"));
	Иначе	
		Схема = Новый СхемаКомпоновкиДанных;
		Источник = Схема.ИсточникиДанных.Добавить();
		Источник.Имя = "ИсточникДанных1";
		Источник.ТипИсточникаДанных = "Local";
		
		нд=Схема.НаборыДанных.Найти("ДанныеФайла");
		Если нд=неопределено Тогда
			нд=Схема.НаборыДанных.Добавить(тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
			нд.Имя="ДанныеФайла";
			нд.ИмяОбъекта="ДанныеФайла";
			нд.ИсточникДанных="ДанныеФайла";
			Для каждого Колонка из Объект.Колонки Цикл
				поле=нд.Поля.Добавить(тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
				поле.поле=Колонка.Имя;
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(Тип(Колонка.Тип));
				поле.ТипЗначения=новый ОписаниеТипов(МассивТипов);
			КонецЦикла;
		КонецЕсли;
		
		
		
		
		Возврат Схема;
	КонецЕсли;
#КонецЕсли

КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда	
		УстановитьСхемуКомпоновкиДанныхКлиент(ВыбранноеЗначение);
	#КонецЕсли
КонецПроцедуры

Процедура УстановитьСхемуКомпоновкиДанныхКлиент(Схема)
	//обСправочника=ДанныеФормыВЗначение(Объект,Тип("СправочникОбъект.остШаблоныЗагрузки"));
	//обСправочника.СКД=новый ХранилищеЗначения(Схема);
	//ЗначениеВДанныеФормы(обСправочника,Объект);
	//Записать();
//	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
Если РольДоступна("ПолныеПрава") Тогда
		Модифицированность = Истина;

		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
		СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Схема, "dataCompositionSchema", "http://v8.1c.ru/8.1/data-composition-system/schema");
		Объект.СКД = ЗаписьXML.Закрыть();
	КонецЕсли
//	#КонецЕсли
	
КонецПроцедуры


//Функция ПолучитьСхему() Экспорт 
//	обСправочника=ДанныеФормыВЗначение(Объект,Тип("СправочникОбъект.остШаблоныЗагрузки"));
//	
//	Схема = обСправочника.СКД.Получить();
//	Если Схема = Неопределено Тогда 
//		Схема = Новый СхемаКомпоновкиДанных;
//		Источник = Схема.ИсточникиДанных.Добавить();
//		Источник.Имя = "ИсточникДанных1";
//		Источник.ТипИсточникаДанных = "Local";
//	КонецЕсли;
//	
//	Возврат Схема;
//КонецФункции


//Процедура СКД(Команда)
//	// Вставить содержимое обработчика.
//КонецПроцедуры
