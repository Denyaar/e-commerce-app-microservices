/**
 * Created by tendaimupezeni for e-commerce-app
 * Date: 6/9/24
 * Time: 11:12 PM
 */

package com.denyaar.notificationservice.notification;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationRepository extends MongoRepository<Notification, String> {
}
