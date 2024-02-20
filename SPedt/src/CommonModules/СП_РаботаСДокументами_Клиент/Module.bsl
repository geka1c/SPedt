Процедура ПриОткрытии(ЭтотОбъект) Экспорт
	//Если 		ЭтотОбъект.Объект.Ссылка.Проведен	и
	//		не 	РольДоступна("СП_КорректеровкаПроведенных") Тогда
	//	ЭтотОбъект.ТолькоПросмотр = истина;
	//	ПоказатьПредупреждение(, "Редактирование проведенных документов запрещено. Обратитесь к Администратору!",,);
	//КонецЕсли;		
			
КонецПроцедуры	

Процедура 	ПроверитьОтветственного(ЭтотОбъект, Отказ) Экспорт
	Если ЭтотОбъект.Объект.Свойство("Ответственный") Тогда
		Если аСПСлужебные.ПроверятьОтветственного() и  не ЗначениеЗаполнено(ЭтотОбъект.Объект.Ответственный) Тогда
			Сообщить("Необходимо установить ответственного за выдачу!!!");
			Отказ=Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

Функция 	ЗаписатьДокумент(УФ_Документа, ПараметрыЗаписи =  Неопределено, Ответственный = Неопределено)Экспорт
	Если Ответственный <> Неопределено Тогда
		УФ_Документа.Объект.Ответственный	=	Ответственный;
	КонецЕсли;
	Если ПараметрыЗаписи =  Неопределено Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи, РежимПроведения",
											РежимЗаписиДокумента.Проведение,
											РежимПроведенияДокумента.Оперативный);
	КонецЕсли;
	Попытка
		записан	= УФ_Документа.Записать(ПараметрыЗаписи);
		ОповеститьОбИзменении(УФ_Документа.Объект.Ссылка);
		Если не Записан Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ не записан");
		КонецЕсли;
		Возврат записан;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ не записан" + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;

КонецФункции

Процедура ОткрытьФорму_Расходная(ПараметрыКарты)  Экспорт
	Если   аСППрверкиКлиент.НаличиеОткрытыхОкон("Расходная") Тогда
    	Предупреждение("Существует не завершенная операция ВЫДАЧИ.Закройте все окна РАСХОДА и повторите попытку!!!",30,"Предупреждение");
		Возврат;		
	КонецЕсли;
	
	//Окна = ПолучитьОкна();
	//Для каждого элем из Окна Цикл
	//	Если элем.НачальнаяСтраница	Тогда
	//		ОкноРабочийСтол = элем;	
	//	КонецЕсли;	
	//КонецЦикла;
	//
	//ОповещениеПослеЗакрытия = новый ОписаниеОповещения("ПослеЗакрытияФормы",СП_РаботаСДокументами_Клиент);
	//ОткрытьФорму("Документ.Расходная.Форма.ФормаДокумента",ПараметрыКарты,ОкноРабочийСтол ,,,,ОповещениеПослеЗакрытия);
	
	
	форма=ПолучитьФорму("Документ.Расходная.ФормаОбъекта",ПараметрыКарты,,Истина);
	//ДанныеФормы = Форма.Объект;
	//
	//СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы,ПараметрыКарты);
	//СП_РаботаСДокументами.ЗаполнитьФорму_Расходная_ОстаткамиТоваров(ДанныеФормы);
	//КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
	Форма.Открыть();
КонецПроцедуры

Процедура ПослеЗакрытияФормы(Резцльтат,Дополнительныепараметры)  Экспорт
	// Окна = ПолучитьОкна();
	//Для каждого элем из Окна Цикл
	//	Если элем.НачальнаяСтраница	Тогда
	//		а=1;	
	//	КонецЕсли;	
	//КонецЦикла;	
КонецПроцедуры

Процедура ОткрытьФорму_Приходная(ПараметрыЗаказа)  Экспорт
	Если   аСППрверкиКлиент.НаличиеОткрытыхОкон("Приходная") Тогда
    	Предупреждение("Существует не завершенная операция Поступления.Закройте все окна Прихода и повторите попытку!!!",30,"Предупреждение");
		Возврат;		
	КонецЕсли;
	
	Если ПараметрыЗаказа.Свойство("Посылка") Тогда
		Параметры = новый Структура("Транзит,ПунктВыдачи, Посылка ",ПараметрыЗаказа.Транзит,ПараметрыЗаказа.ПунктВыдачи, ПараметрыЗаказа.Посылка);
		
		ОткрытьФорму("Документ.Приходная.ФормаОбъекта",Параметры,,,,,,) ;

	Иначе
		форма		= ПолучитьФорму("Документ.Приходная.ФормаОбъекта");
		ДанныеФормы = Форма.Объект;
		СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы,новый Структура("Транзит,ПунктВыдачи ",ПараметрыЗаказа.Транзит,ПараметрыЗаказа.ПунктВыдачи));
		КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
		Форма.Открыть();
	КонецЕсли;
КонецПроцедуры


Процедура ОткрытьФорму_РазборКоробки(ПараметрыКоробки)  Экспорт
	Если   аСППрверкиКлиент.НаличиеОткрытыхОкон("Разбор") Тогда
    	Предупреждение("Существует не завершенная операция Разбора коробки .Закройте и повторите попытку!!!",30,"Предупреждение");
		Возврат;		
	КонецЕсли;

	форма		= ПолучитьФорму("Документ.РазборКоробки.ФормаОбъекта");
	ДанныеФормы = Форма.Объект;
	Если ПараметрыКоробки.Свойство("Супергруппа") Тогда
		СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы,новый Структура("Супергруппа",ПараметрыКоробки.Супергруппа));
	Иначе	
		СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы,новый Структура("Организатор, Коробки ",ПараметрыКоробки.Организатор, ПараметрыКоробки));
	КонецЕсли;	
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
	Форма.Открыть();
	
КонецПроцедуры


Процедура ОткрытьФорму_Продажа(Параметры)  Экспорт
	Если   аСППрверкиКлиент.НаличиеОткрытыхОкон("Продажа") Тогда
    	Предупреждение("Существует не завершенная операция Продажи. Закройте и повторите попытку!!!",30,"Предупреждение");
		Возврат;		
	КонецЕсли;

	форма		= ПолучитьФорму("Документ.Продажа.ФормаОбъекта",Параметры);
	ДанныеФормы = Форма.Объект;
	СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы,новый Структура("Участник",Параметры.Участник));
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
	Форма.Открыть();
	
КонецПроцедуры


Процедура ОткрытьКорректировкуПоступления(Ссылка, Владелец) Экспорт
	Если не ЗначениеЗаполнено(Ссылка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ не записан");
		Возврат;
	КонецЕсли;
	ПараметрыЗаполнения= Новый Структура();
	ПараметрыЗаполнения.Вставить("ДатаОтчета", 		ТекущаяДата());
	ПараметрыЗаполнения.Вставить("Партия", 			новый структура("ПравоеЗначение, Использование, ВидСравнения",Ссылка, Истина, ВидСравненияКомпоновкиДанных.Равно) );
	//		ПараметрыЗаполнения.Вставить("Партия", 			Объект.Ссылка);
	
//	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОткрытияДвижения",ЭтаФорма);
	
	ОткрытьФорму("Документ.Движение.ФормаОбъекта",Новый структура("ПараметрыЗаполнения",ПараметрыЗаполнения) ,Владелец,,,,  );
КонецПроцедуры


Процедура ОткрытьКорректировкуПоступленияТранзит(Ссылка, Владелец) Экспорт
		//ПунктВыдачи 		= Элементы.СостоянияОтгрузки.ТекущиеДанные.ПунктВыдачи;
		ПараметрыЗаполнения	= Новый Структура();

		ПараметрыЗаполнения.Вставить("ДатаОтчета", 		КонецДня(ТекущаяДата()));
		ПараметрыЗаполнения.Вставить("Партия", 			новый структура("ПравоеЗначение, Использование, ВидСравнения",Ссылка, Истина, ВидСравненияКомпоновкиДанных.Равно) );
		
//    	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияформыДокумента",ЭтаФорма);
	
		ОткрытьФорму("Документ.ДвижениеТранзита.ФормаОбъекта",Новый структура("ПараметрыЗаполнения",ПараметрыЗаполнения) ,Владелец,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс  );

КонецПроцедуры
