//
//  NotificationViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/30/21.
//

import UIKit

struct NotificationViewModel {
    
    func stickerCell(_ tableView: UITableView) -> StickerTableViewCell {
        let stickerCell = tableView.dequeueReusableCell(withIdentifier: Strings.stickerTableViewCell) as! StickerTableViewCell
        return stickerCell
    }
    
    func setup(_ stickerCell: StickerTableViewCell,
               _ indexPath: IndexPath,
               _ userStickerViewModel: [UserStickerViewModel],
               _ notificationVC: NotificationViewController)
    {
        stickerCell.prepareStickerTableViewCell()
        stickerCell.userStickerViewModel = userStickerViewModel[indexPath.row]
        stickerCell.stickerCellDelegate = notificationVC
    }
    
    func stickerOptionVC(_ userStickerViewModel: [UserStickerViewModel], _ indexPath: IndexPath) -> StickerOptionViewController {
        let stickerOptionVC = Utilities.transition(to: Strings.stickerOptionVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! StickerOptionViewController
        stickerOptionVC.userStickerViewModel = userStickerViewModel[indexPath.row]
        stickerOptionVC.modalPresentationStyle = .fullScreen
        return stickerOptionVC
    }
    
}
