//
// Created by Vlad Hatko on 5/3/16.
// Copyright (c) 2016 Hatcom. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar

class ScheduleViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewWithCalendar: UIView!
    
    private var selectedDate: CVDate!

    @IBOutlet weak var calendarBottom: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!

    private var lessons : [BaseLesson]? = []
    private var lessonsSeparatedByDays : [[BaseLesson]]! = [[],[],[],[],[],[],[]]//0 for monday
    private var lessonsForCurrentDate : [BaseLesson] = []

    enum ViewType {
        case List, Grid
    }

    var viewType = ViewType.List

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = UserManager.sharedInstance.currentLector!.name

        selectedDate = CVDate(date: NSDate())

        lessons = UserManager.sharedInstance.userLessons

        if lessons != nil {
            for lesson in lessons! {
                lessonsSeparatedByDays[lesson.dayOfWeek!].append(lesson)
            }
        }

        invalidateLessonsForDate()
    }

    private func invalidateLessonsForDate() {
        if lessons != nil {
            lessonsForCurrentDate = lessonsSeparatedByDays[selectedDate.getDayOfWeek()]
        }

        tableView.hidden = lessonsForCurrentDate.count == 0
    }

    @IBAction func viewBarButtonTapped(sender: UIBarButtonItem) {
        if viewType == .List {
            viewType = .Grid

            sender.image = UIImage(named: "listViewIcon.png")
            view.layoutIfNeeded()

            calendarBottom.constant = viewWithCalendar.frame.size.height
        } else {
            viewType = .List

            sender.image = UIImage(named: "calendarIcon.png")
            view.layoutIfNeeded()

            calendarBottom.constant = 0
        }

        invalidateTitle()

        UIView.animateWithDuration(0.3, animations: {
            () -> Void in
            self.view.layoutIfNeeded()
        })
    }

    private func invalidateTitle() {
        let dateString = "\(selectedDate.day).\(selectedDate.month).\(selectedDate.year)"

        if viewType == .List {
            navigationItem.title = selectedDate.isToday() ? "Schedule" : "Schedule " + dateString
        } else {
            navigationItem.title = selectedDate.isToday() ? "Today Lessons" : "Lessons for " + dateString
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    
    //MARK: CVCalendarViewDelegate
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Monday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        let newDate = dayView.date
        
        if newDate != selectedDate {
            selectedDate = dayView.date

            invalidateLessonsForDate()

            tableView.reloadData()

            invalidateTitle()
        }
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.redColor()]
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        return lessonsSeparatedByDays[dayView.date.getDayOfWeek()].count > 0
    }
}


private typealias TableViewDataSource = ScheduleViewController
extension TableViewDataSource : UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6//6 lessons per day
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lLessonListId", forIndexPath: indexPath) as! LessonCell
        cell.lessonNumberLabel.text = "\(indexPath.row)"

        if let lesson = lessonsForCurrentDate.filter({
            (selectedLesson: BaseLesson) -> Bool in
            return selectedLesson.numberOfLesson == indexPath.row
        }).first {
            cell.textLabel!.text = lesson.discipline!.name
            cell.detailTextLabel!.text = lesson.room
        } else {

        }

        return cell
    }
}


extension CVDate {
    public func isToday() -> Bool {
        let today = CVDate(date: NSDate())

        return today.day == day && today.month == month && today.year == year
    }

    func getDayOfWeek()->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: convertedDate()!)
        let weekDay = myComponents.weekday
        return weekDay - 2 < 0 ? 6 : weekDay - 2//subtract 2 to make monday the 0th day
    }
}


class LessonCell : UITableViewCell{
    @IBOutlet weak var lessonNumberLabel: UILabel!
}
