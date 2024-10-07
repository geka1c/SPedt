#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


	Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)	
		УстановленныеПараметры = СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
		// УниверсальныеМеханизмы
		Если ИменаПараметровСеанса = Неопределено Тогда
			
			// раздел безусловной установки параметров сеанса
			
			// Конец УниверсальныеМеханизмы
			
			// Переопределяемый блок
			//
			// Конец переопределяемого блока
			
			// УниверсальныеМеханизмы
		Иначе
			// установка параметров сеанса "по требованию"
			
			// параметры сеанса, инициализация которых требует обращения к одним и тем же данным
			// следует инициализировать сразу группой. для того, чтобы избежать их повторной инициализации, 
			// имена уже установленных параметров сеанса сохраняются в структуре УстановленныеПараметры
			УстановленныеПараметры = Новый Массив();
			Для Каждого ИмяПараметра Из ИменаПараметровСеанса Цикл
				УстановитьЗначениеПараметраСеанса(ИмяПараметра, УстановленныеПараметры);
			КонецЦикла;
			                                 											 
		КонецЕсли;
		// Конец УниверсальныеМеханизмы
		
	КонецПроцедуры

Процедура УстановитьЗначениеПараметраСеанса(Знач ИмяПараметра, УстановленныеПараметры)
	
	// Конец УниверсальныеМеханизмы
	Если УстановленныеПараметры.Найти(ИмяПараметра) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	// Конец УниверсальныеМеханизмы

	// Переопределяемый блок

	//ПодключаемоеОборудование
	МенеджерОборудованияВызовСервера.УстановитьПараметрыСеансаПодключаемогоОборудования(ИмяПараметра, УстановленныеПараметры);
	// Конец ПодключаемоеОборудование

	// Конец переопределяемого блока
	
	ПараметрыСеанса.РазрешитьИзменения = Документы.Расходная.ПустаяСсылка();;
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСеанса.ВерсияРасширений = Справочники.ВерсииРасширений.ПустаяСсылка();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецЕсли